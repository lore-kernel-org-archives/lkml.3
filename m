Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3IRPjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:39:08 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:13365 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3IRPjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:39:06 -0400
Message-ID: <1379518742.1522.23.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 004/007] WAN Drivers: Update farsync driver and
 introduce fsflex driver
From: Ben Hutchings <bhutchings@solarflare.com>
To: Kevin Curtis <Kevin.Curtis@farsite.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Dermot Smith" <dermot.smith@farsite.com>
Date: Wed, 18 Sep 2013 16:39:02 +0100
In-Reply-To: <E603DC592C92B54A89CEF6B0919A0B1CAAAA787DA3@SOLO.hq.farsitecommunications.com>
References: <E603DC592C92B54A89CEF6B0919A0B1CAAAA787DA3@SOLO.hq.farsitecommunications.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20158.002
X-TM-AS-Result: No--17.611800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 11:12 +0100, Kevin Curtis wrote:
> Farsite Communications FarSync driver update
> 
> Patch 4 of 7
> Note that this patch must be applied with patch 5 (farsync_driver_patch)

Then don't make them separate patches.

> Update the existing farsync.h file for the new features of the farsync and
> flex drivers.
> 
> Signed-off-by: Kevin Curtis <kevin.curtis@farsite.com>
> 
> ---
> diff -uprN -X linux-3.10.1/Documentation/dontdiff linux-3.10.1/drivers/net/wan/farsync.h linux-3.10.1_new/drivers/net/wan/farsync.h
> --- linux-3.10.1/drivers/net/wan/farsync.h      2013-07-13 19:42:41.000000000 +0100
> +++ linux-3.10.1_new/drivers/net/wan/farsync.h  2013-09-16 16:30:06.483104880 +0100
[...]
> +#ifdef __x86_64__
> +#define FST_PLATFORM            "64bit"
> +#else
> +#define FST_PLATFORM            "32bit"
> +#endif

Really, there are a lot more 64-bit architectures than that...

> +#define FST_ADDITIONAL          FST_BUILD_NO
> +
> +#define FST_INCLUDES_CHAR
> +
> +struct fst_device_stats {
> +       unsigned long rx_packets;       /* total packets received       */
> +       unsigned long tx_packets;       /* total packets transmitted    */
> +       unsigned long rx_bytes; /* total bytes received         */
> +       unsigned long tx_bytes; /* total bytes transmitted      */
> +       unsigned long rx_errors;        /* bad packets received         */
> +       unsigned long tx_errors;        /* packet transmit problems     */
> +       unsigned long rx_dropped;       /* no space in linux buffers    */
> +       unsigned long tx_dropped;       /* no space available in linux  */
> +       unsigned long multicast;        /* multicast packets received   */
> +       unsigned long collisions;
> +
> +       /* detailed rx_errors: */
> +       unsigned long rx_length_errors;
> +       unsigned long rx_over_errors;   /* receiver ring buff overflow  */
> +       unsigned long rx_crc_errors;    /* recved pkt with crc error    */
> +       unsigned long rx_frame_errors;  /* recv'd frame alignment error */
> +       unsigned long rx_fifo_errors;   /* recv'r fifo overrun          */
> +       unsigned long rx_missed_errors; /* receiver missed packet       */
> +
> +       /* detailed tx_errors */
> +       unsigned long tx_aborted_errors;
> +       unsigned long tx_carrier_errors;
> +       unsigned long tx_fifo_errors;
> +       unsigned long tx_heartbeat_errors;
> +       unsigned long tx_underrun_errors;
> +
> +       /* for cslip etc */
> +       unsigned long rx_compressed;
> +       unsigned long tx_compressed;
> +};

Why do you need your own copy of struct net_device_stats?

[...]
>  /*      Ioctl call command values
> + *
> + *      The first three private ioctls are used by the sync-PPP module,
> + *      allowing a little room for expansion we start our numbering at 10.
>   */
> -#define FSTWRITE        (SIOCDEVPRIVATE+10)
> -#define FSTCPURESET     (SIOCDEVPRIVATE+11)
> -#define FSTCPURELEASE   (SIOCDEVPRIVATE+12)
> -#define FSTGETCONF      (SIOCDEVPRIVATE+13)
> -#define FSTSETCONF      (SIOCDEVPRIVATE+14)
> -
> +#define FSTWRITE        (SIOCDEVPRIVATE+4)
> +#define FSTCPURESET     (SIOCDEVPRIVATE+5)
> +#define FSTCPURELEASE   (SIOCDEVPRIVATE+6)
> +#define FSTGETCONF      (SIOCDEVPRIVATE+7)
> +#define FSTSETCONF      (SIOCDEVPRIVATE+8)
> +#define FSTSNOTIFY      (SIOCDEVPRIVATE+9)
> +#define FSTGSTATE       (SIOCDEVPRIVATE+10)
> +#define FSTSYSREQ       (SIOCDEVPRIVATE+11)
> +#define FSTGETSHELL     (SIOCDEVPRIVATE+12)
> +#define FSTSETMON       (SIOCDEVPRIVATE+13)
> +#define FSTSETPORT      (SIOCDEVPRIVATE+14)
> +#define FSTCMD          (SIOCDEVPRIVATE+15)
[...]

No, you must never renumber ioctls once they're used in production.

It's hard to know what other changes you're making, because of all the
whitespace fixes.  It would be clearer if you fixed up the whitespace in
the existing header as a preparatory patch.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

