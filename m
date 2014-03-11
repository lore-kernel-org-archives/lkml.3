Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaCKO1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:27:51 -0400
Received: from smtprelay0110.hostedemail.com ([216.40.44.110]:50568 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753162AbaCKO1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:27:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3770:3865:3867:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:7576:7652:7901:7903:8599:8985:9025:10004:10400:10848:11232:11658:11914:12043:12050:12517:12519:12555:12682:12740:13019:13069:13311:13357,0,RBL:none
X-HE-Tag: pet80_92040b657f52
X-Filterd-Recvd-Size: 1524
Message-ID: <1394548060.21085.45.camel@joe-AO722>
Subject: Re: [PATCH 1/4] serial: sh-sci: Replace printk() by pr_*()
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-serial@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Date: Tue, 11 Mar 2014 07:27:40 -0700
In-Reply-To: <1394532680-4264-1-git-send-email-geert@linux-m68k.org>
References: <1394532680-4264-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 11:11 +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Make banner const while we're at it

One thing to consider is to add

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include to make sure all messages
are appropriately prefixed by subsystem name.

One day, I'd very much like to avoid this
by making it the default.

http://comments.gmane.org/gmane.linux.kernel/1052288



