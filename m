Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3C1KeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 06:34:09 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:53314 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab3C1KeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:34:07 -0400
Message-ID: <51541C9B.4000802@suse.cz>
Date: Thu, 28 Mar 2013 11:34:03 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>, mathieu.poirier@linaro.org
CC: LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Out-of-bound access in sysrq
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys,

how is this supposed to work?

#define SYSRQ_KEY_RESET_MAX     20 /* Should be plenty */
static unsigned short sysrq_reset_seq[SYSRQ_KEY_RESET_MAX];
...
unsigned short platform_sysrq_reset_seq[] __weak = { KEY_RESERVED };
...
static inline void sysrq_register_handler(void)
{
...
        for (i = 0; i < ARRAY_SIZE(sysrq_reset_seq); i++) {
                key = platform_sysrq_reset_seq[i];
                if (key == KEY_RESERVED || key > KEY_MAX)
...




i runs from 0 to 19 incl., but platform_sysrq_reset_seq, if not
overriden, is of size 1, so?

thanks,
-- 
js
suse labs
