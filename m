Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaDWAmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 20:42:39 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35877 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaDWAmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 20:42:37 -0400
Date: Tue, 22 Apr 2014 17:42:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sheng-Liang Song <ssl@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Shawn Nematbakhsh <shawnn@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: atkbd - fix keyboard LG Electronics
Message-ID: <20140423004233.GC22547@core.coreip.homeip.net>
References: <1398185970-16331-1-git-send-email-ssl@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398185970-16331-1-git-send-email-ssl@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sheng-Liang,

On Tue, Apr 22, 2014 at 09:59:30AM -0700, Sheng-Liang Song wrote:
> After issuing ATKBD_CMD_RESET_DIS, LG Keyboard stop working.
> The workaround is to issue ATKBD_CMD_RESET_DEF after ATKBD_CMD_RESET_DIS.

Hmm, if ATKBD_CMD_RESET_DIS causes keyboard not working should we
simply not call it on LG devices?

The idea for using ATKBD_CMD_RESET_DIS was for keyboard to stop
generating scan codes so they do not interfere with detection/resume and
issuing ATKBD_CMD_RESET_DEF right after ATKBD_CMD_RESET_DIS keeps
keyboard in exactly the same state as it was before (i.e. generating
scancodes).

Thanks.

-- 
Dmitry
