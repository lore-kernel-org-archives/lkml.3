Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3ANIIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:08:21 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:56668 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab3ANIIV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Mon, 14 Jan 2013 03:08:21 -0500
Message-Id: <50F3CAFD02000078000B52BE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 14 Jan 2013 08:08:13 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <linux@rainbow-software.org>
Cc: <dmitry.torokhov@gmail.com>, <hpa@linux.intel.com>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>
Subject: your patch "x86, 8042: Enable A20 using KBC to fix S3 resume
 on some MSI laptops"
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej,

I see two problems with this patch: For one, on a system without
i8042 the code at the place it got inserted ought to incur a stall of
1s (50us * I8042_CTL_TIMEOUT [10000] * 2). I believe that this
code should not be run before i8042_controller_check() completed
successfully, but at the very least the second call to
i8042_command() should be conditional upon the first being
successful (effectively halving the stall).

Second, considering that enabling A20 (even if just in a fake way),
is a core system operation, I don't think it belongs into a driver
that is only optionally present in the kernel.

Jan

