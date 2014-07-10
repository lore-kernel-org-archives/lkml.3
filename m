Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaGJS1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:27:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51446 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaGJS1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:27:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAFQmdRb-qENEhFrEeNzvBrMuBjusZcxvhanTuzL9VmKncv-1Tg@mail.gmail.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-4-git-send-email-hskinnemoen@google.com>
	<3908561D78D1C84285E8C5FCA982C28F32857499@ORSMSX114.amr.corp.intel.com>
	<CAFQmdRYabFy84FxeJGbrdd6w5O0mu9Kn_jE5V4rpw7cBrMvb0w@mail.gmail.com>
	<20140710162419.GK2970@pd.tnic>
	<CAFQmdRb-qENEhFrEeNzvBrMuBjusZcxvhanTuzL9VmKncv-1Tg@mail.gmail.com>
Date: Thu, 10 Jul 2014 11:27:00 -0700
Message-ID: <CA+8MBbLO0=0G2GHNd797JNcZuJ2ZOQuNuvyGRLehBq0VXNHOhA@mail.gmail.com>
Subject: Re: [PATCH 3/6] x86-mce: Clear CMCI enable on all claimed CMCI banks
 before reboot.
From: Tony Luck <tony.luck@gmail.com>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 10:56 AM, Havard Skinnemoen
<hskinnemoen@google.com> wrote:
> Even on kexec-enabled kernels, we might be doing a regular BIOS boot.
> Is there any way to detect that we're doing a kexec boot and only
> clearing the MSRs in that case?

I'm not sure if we should worry about that ... not having the code bloat
for the functions is kexec is not configured is a good goal. Worrying
about a few extra microseconds in the shutdown path if kexec is configured
but we are actually doing a normal shutdown/reboot doesn't seem as
big of a worry.

-Tony
