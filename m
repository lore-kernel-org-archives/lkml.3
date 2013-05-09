Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3EIJv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:51:29 -0400
Received: from mx0.aculab.com ([213.249.233.131]:58586 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751234Ab3EIJv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:51:28 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 07/21] netfilter: nf_nat: remove inline marking of EXPORT_SYMBOL functions
Date: Thu, 9 May 2013 10:47:33 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B722B@saturn3.aculab.com>
In-Reply-To: <1368091192-10245-2-git-send-email-yefremov.denis@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 07/21] netfilter: nf_nat: remove inline marking of EXPORT_SYMBOL functions
Thread-Index: Ac5MlnRtHKDmQ4KCSWCO8Kg2uymAMAAAwv2Q
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com> <1368091192-10245-2-git-send-email-yefremov.denis@gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Denis Efremov" <yefremov.denis@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Patrick McHardy" <kaber@trash.net>, <netfilter@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <trivial@kernel.org>, <ldv-project@linuxtesting.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
...
> -inline const struct nf_nat_l4proto *
> +const struct nf_nat_l4proto *
>  __nf_nat_l4proto_find(u8 family, u8 protonum)
>  {
>  	return rcu_dereference(nf_nat_l4protos[family][protonum]);

If it makes sense to inline the local calls (ie the cost
of the call is significant) then possibly add an inlined
(or inlinable) static function that is called locally and
by the exported one?

I'm not sure that gcc is allowed to make the assumption
that the local exported function will be called - and
thus inline it.

	David



