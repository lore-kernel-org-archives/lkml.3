Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbaCQROJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:14:09 -0400
Received: from mx0.aculab.com ([213.249.233.131]:57754 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754891AbaCQROG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:14:06 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'David Herrmann'" <dh.herrmann@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, Tom Gundersen <teg@jklm.no>,
        Johannes berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: RE: [PATCH v3 1/4] net: add name_assign_type netdev attribute
Thread-Topic: [PATCH v3 1/4] net: add name_assign_type netdev attribute
Thread-Index: AQHPQgLHooclFzgDYkaruvDiuB9ar5rlg6Eg
Date: Mon, 17 Mar 2014 17:12:52 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6DF74F@AcuExch.aculab.com>
References: <1394990490-1076-2-git-send-email-dh.herrmann@gmail.com>
 <1395075825-5824-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1395075825-5824-1-git-send-email-dh.herrmann@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Herrmann
> The name_assign_type attribute gives hints where the interface name of a
> given net-device comes from. Three different values are currently defined:
>   NET_NAME_ENUM:
>     This is the default. The ifname is provided by the kernel with an
>     enumerated suffix. Names may be reused and unstable.
>   NET_NAME_USER:
>     The ifname was provided by user-space during net-device setup.
>   NET_NAME_RENAMED:
>     The net-device has been renamed via RTNL. Once this type is set, it
>     cannot change again.
...
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index b8d8c80..6698e87 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1248,6 +1248,7 @@ struct net_device {
>  	 * of the interface.
>  	 */
>  	char			name[IFNAMSIZ];
> +	unsigned char		name_assign_type; /* name assignment type */
> 
>  	/* device name hash chain, please keep it close to name[] */
>  	struct hlist_node	name_hlist;

Do you really need to add 7 byte of padding here?
There seems to be some padding lurking elsewhere that really ought
to be mergable.

	David



