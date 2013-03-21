Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575Ab3CUOhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:37:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3CUOhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:37:24 -0400
Date: Thu, 21 Mar 2013 10:36:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 17/21] vmcore: check NT_VMCORE_PAD as a mark
 indicating the end of ELF note buffer
Message-ID: <20130321143656.GG3934@redhat.com>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
 <20130316040223.15064.77472.stgit@localhost6.localdomain6>
 <87ppyvp014.fsf@xmission.com>
 <20130321.115920.339923125.d.hatayama@jp.fujitsu.com>
 <87r4j98l1q.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4j98l1q.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 08:54:25PM -0700, Eric W. Biederman wrote:

[..]
> > Also, it's possible to get size of a whole part of ELF note segments
> > from p_memsz or p_filesz, and gdb and binutils are reading the note
> > segments until reaching the size.
> 
> Agreed.  Except in our weird case where we generate the notes on the
> fly, and generate the NOTE segment header much earlier.

And in our case we don't know the size of ELF note. Kernel is not
exporting the size. So kexec-tools is putting an upper limit of 1024
and putting that value in p_memsz and p_filesz fields.

Given the fact that we are reserving elf notes at boot. That means
we know the size of ELF notes. It should make sense to export it
to user space and let kexec-tools put right values.

In fact looks like /sys/kernel/vmcoreinfo is exporting two values. Address
and size. (This is kind of violation of sysfs poilcy of one value per
file). But for per cpu notes, we are exporting only address and not
size.

/sys/devices/system/cpu/cpu<n>/crash_notes

May be we should export another file

/sys/devices/system/cpu/cpu<n>/crash_notes_size

and let kexec-tools parse it.

Thanks
Vivek
