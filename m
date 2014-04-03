Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaDCS5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbaDCS5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:57:37 -0400
Message-ID: <533DAF1B.1070502@draigBrady.com>
Date: Thu, 03 Apr 2014 19:57:31 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Reisner <d@falconindy.com>
CC: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: Initramfs FSID altered in 3.14
References: <20140403175744.GE585@rampage>
In-Reply-To: <20140403175744.GE585@rampage>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 06:57 PM, Dave Reisner wrote:
> Hi,
> 
> [This is a repost of a G+ post at Tejun's request]
> 
> With Linux 3.14, you might notice in /proc/self/mountinfo that your
> root's parent FSID is now 0, instead of the 1 that it's been for the
> last N years. Tejun wrote the change (9e30cc9595303b27b48) that caused
> this, but the change comes in a rather innocuous way. Instead of an
> internal kernel mount of sysfs being assigned 0, it's now the initramfs.
> 
> So far, this has already caused switch_root and findmnt (from
> util-linux) to break, cp (from coreutils) to break when using the -x
> flag in early userspace, and it's also been pointed out that systemd's
> readahead code makes assumptions about a device number of 0.

For reference we've changed coreutils not to assume 0 is an invalid device ID:
http://git.sv.gnu.org/gitweb/?p=coreutils.git;a=commit;h=d0294ff3

> Are we now supposed to go and change all the assumptions in userspace
> about 0 being special? I'm conflicted. The kernel isn't supposed to
> break userspace, but it seems to me that FSIDs were never something to
> rely on -- similar to the block device numbering scheme.

I would say the kernel doesn't care what the value is,
so to ease compat worries just use >= 1.

cheers,
Pádraig
