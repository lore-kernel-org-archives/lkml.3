Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3JKWh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:37:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45029 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3JKWh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:37:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ryan Mallon <rmallon@gmail.com>
Cc: George Spelvin <linux@horizon.com>, joe@perches.com,
        akpm@linux-foundation.org, dan.j.rosenberg@gmail.com,
        eldad@fogrefinery.com, jgunthorpe@obsidianresearch.com,
        jkosina@suse.cz, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, rusty@rustcorp.com.au
References: <20131011044232.11545.qmail@science.horizon.com>
	<525875DB.9030300@gmail.com>
Date: Fri, 11 Oct 2013 15:37:32 -0700
In-Reply-To: <525875DB.9030300@gmail.com> (Ryan Mallon's message of "Sat, 12
	Oct 2013 09:04:11 +1100")
Message-ID: <87d2nba0yb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19/zSaKNXANGj8DL24U5AYRd/Iq5AcyWLw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0008]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ryan Mallon <rmallon@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Mallon <rmallon@gmail.com> writes:

> The only remaining problem is kernel/module.c:module_sect_show() which
> is used to write the sysfs files in /sys/module/<modname>/sections/.
> Those files are actually are really good target for leaking %pK values
> via setuid binaries. The problem is that the module_sect_show() function
> isn't passed information about who opened the sysfs file. I don't think
> this information is available in general for sysfs files either. Also,
> I can't actually see how module_sect_show() gets called?
>
> I'm a bit stuck on how to solve this. Any ideas?

I haven't yet had a chance to review the patches but there are patches
to make sysfs files seq files in Greg's driver core tree.

Eric
