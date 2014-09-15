Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaIOSP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:15:57 -0400
Received: from mailsec102.isp.belgacom.be ([195.238.20.98]:60870 "EHLO
	mailsec102.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764AbaIOSP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:15:56 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=xmGiAQlKtCF5+ra7FDB8hpYjXxwBLBdzsqYiSFHyMzI= c=1 sm=2
 a=bkJMK2Ci7R8A:10 a=0DbHbE-t3RIA:10 a=IkcTkHD0fZMA:10 a=z1H5ADGQAAAA:8
 a=gu6fZOg2AAAA:8 a=nfjYZqEwXPAwufWFbCAA:9 a=QEXdDO2ut3YA:10
 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10 a=Ayxay6nOzaQnOsfV:21
 a=ku750LCIVVWYbtpL:21
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsMAHksF1TD7hTS/2dsb2JhbABhgw1TVwGCe7BNAQaXHodOAYEXFniEAwEBAQMBI1YFCwUGGAICGA4CAlcGExGIJQwJpXSGf45RAReBLIRQiVEHgniBUwWWBIhjilGJD4NgOy+CSgEBAQ
Date: Mon, 15 Sep 2014 20:15:54 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, peter@hurleysoftware.com
Message-ID: <1669797975.16695.1410804954304.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140915001356.2e05d782@alan.etchedpixels.co.uk>
References: <1410712823-29137-1-git-send-email-fabf@skynet.be> <20140915001356.2e05d782@alan.etchedpixels.co.uk>
Subject: Re: [PATCH 0/9 linux-next] drivers/gpu/drm: use container_of where
 possible
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 15 September 2014 at 01:13 One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
> wrote:
>
>
> On Sun, 14 Sep 2014 18:40:13 +0200
> Fabian Frederick <fabf@skynet.be> wrote:
>
> > Small patchset using container_of instead of casting on first structure
> > member address.
>
> Why. Container_of is useful for random offsets but its just convoluting
> and confusing code which is designed with the fields intentionally at the
> start.
>
> Alan

What if someone doesn't know about that intention one day and inserts
some field in the structure at the "wrong place" ?
This would need at least some comment in each declaration
but once again it's hard to control.One other way is to
commonly use container_of and get rid of every casting with
some semantic script.

Peter has been asking for container_of in the following:

http://marc.info/?l=linux-arm-kernel&m=140838705729653&w=2


struct uart_amba_port *uap = (struct uart_amba_port *)port

(port/uart_port is the first field in uart_amba_port though)

Regards,
Fabian
