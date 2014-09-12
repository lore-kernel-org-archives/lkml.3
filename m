Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaILD5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:57:23 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:47135 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaILD5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:57:22 -0400
MIME-Version: 1.0
Date: Fri, 12 Sep 2014 13:57:20 +1000
Message-ID: <CAPM=9tyZF2S7PJcLyc=KH_NBFXju8UwvMBOF_MocNK8pPVXDYw@mail.gmail.com>
Subject: vga and 64-bit memcpy's
From: Dave Airlie <airlied@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got an bug report from someone using a silicon motion video card in
VGA mode about corruption that they tracked down to 64-bit memory
operations not being supported by the video card, it appears that we
probably shouldn't be using > 32-bit copies on VGA memory.

The include/linux/vt_buffer.h defaults scr_memcpyw defaults to using
memcpy, which on 64-bit x86 machines ends up as rep movsq. Is there
any way to make this use a 32-bit memcpy instead?

Dave.
