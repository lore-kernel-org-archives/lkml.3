Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbbAGKMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:12:42 -0500
Received: from smtp-out4.electric.net ([192.162.216.184]:59052 "EHLO
	smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbbAGKMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:12:39 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Ani Sinha'" <ani@arista.com>, "corbet@lwn.net" <corbet@lwn.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "P@draigbrady.com" <P@draigbrady.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "fruggeri@arista.com" <fruggeri@arista.com>
Subject: RE: [PATCH 1/1] update ip-sysctl.txt documentation
Thread-Topic: [PATCH 1/1] update ip-sysctl.txt documentation
Thread-Index: AQHQKgl5VVPZQ6+Wr0qNPFoMBOPU3Zy0bwaw
Date: Wed, 7 Jan 2015 10:11:30 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CAC2762@AcuExch.aculab.com>
References: <1420587382-24612-1-git-send-email-ani@arista.com>
In-Reply-To: <1420587382-24612-1-git-send-email-ani@arista.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Outbound-IP: 213.249.233.130
X-Env-From: David.Laight@ACULAB.COM
X-PolicySMART: 3396946, 3397078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ani Sinha
> Update documentation to reflect the fact that
> /proc/sys/net/ipv4/route/max_size is no longer used for ipv4.
> 
> Signed-off-by: Ani Sinha <ani@arista.com>
> ---
>  Documentation/networking/ip-sysctl.txt |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index 9bffdfc..2a28261 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -64,8 +64,10 @@ fwmark_reflect - BOOLEAN
>  	Default: 0
> 
>  route/max_size - INTEGER
> -	Maximum number of routes allowed in the kernel.  Increase
> -	this when using large numbers of interfaces and/or routes.
> +	Post linux kernel 3.6, this is deprecated for ipv4 as route cache is no
> +	longer used. For ipv6, this is used to limit the maximum number of ipv6
> +	routes allowed in the kernel.  Increase this when using large numbers of
> +	interfaces and/or routes.

Now imagine you are reading ip-sysctl.txt, the new text is all wrong.
Something like:
	Limit on the size of the ip route caches.
	Ignored for ipv4 after kernel 3.6 because the ipv4 route cache was removed.
	Increase this when using large numbers of interfaces and/or routes.
would read better.

	David

