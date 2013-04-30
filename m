Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab3D3VVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932826Ab3D3VVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:21:49 -0400
Date: Tue, 30 Apr 2013 17:20:07 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: clockevents_program_event WARN_ON preventing boot.
Message-ID: <20130430212007.GB18598@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a machine that crashes instantly on boot up on Linus'
post-3.9 tree. (8c55f1463c1fd318d5e785f02b80bcc32176d342)

By booting with boot_delay=100, I was able to take a photo
and capture the top of the trace.  (For some reason, larger boot
delay parameters seem to make it take forever before printing
even a single character, which made this a pain to debug).

The WARN_ON it prints right before locking up is this in clockevents_program_event

208         if (unlikely(expires.tv64 < 0)) {
209                 WARN_ON_ONCE(1);
210                 return -ETIME;
211         }

booting with maxcpus=1 avoids the problem.

I'm still trying to get a complete stack trace, though it's painful
due to the above reason.

	Dave

