Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3J3PP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:15:57 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:36663 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3J3PPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:15:54 -0400
MIME-Version: 1.0
In-Reply-To: <20131030142017.GB30896@kroah.com>
References: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
 <1383132636-8952-2-git-send-email-bergwolf@gmail.com> <20131030132101.GD30087@kroah.com>
 <CA+a=Yy6rL6CV3THZ4Mr4oHqVDiejr++r9Oa4kro4Y_CCbFEfEQ@mail.gmail.com> <20131030142017.GB30896@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 30 Oct 2013 23:15:32 +0800
Message-ID: <CA+a=Yy5+3tOYikUR161-QbG3+mCr6FH1P0-5QHp4TjoC=FWK8A@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging/lustre/obdclass: read jobid from proc
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 10:20 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Oct 30, 2013 at 09:31:24PM +0800, Peng Tao wrote:
>> On Wed, Oct 30, 2013 at 9:21 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Wed, Oct 30, 2013 at 07:30:34PM +0800, Peng Tao wrote:
>> >> so that we can get rid of cfs_get_environ() that needs access_process_vm() that
>> >> is a core mm function and is not available on some architectures.
>> >>
>> >> Reviewed-by: Niu Yawei <yawei.niu@intel.com>
>> >> Signed-off-by: Peng Tao <bergwolf@gmail.com>
>> >> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>> >> ---
>> >>  drivers/staging/lustre/lustre/obdclass/class_obd.c |  119 +++++++++++++++++++-
>> >>  1 file changed, 115 insertions(+), 4 deletions(-)
>> >>
>> >> diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
>> >> index b1024a6..99ce863 100644
>> >> --- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
>> >> +++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
>> >> @@ -96,8 +96,117 @@ EXPORT_SYMBOL(obd_dirty_transit_pages);
>> >>  char obd_jobid_var[JOBSTATS_JOBID_VAR_MAX_LEN + 1] = JOBSTATS_DISABLE;
>> >>  EXPORT_SYMBOL(obd_jobid_var);
>> >>
>> >> -/* Get jobid of current process by reading the environment variable
>> >> - * stored in between the "env_start" & "env_end" of task struct.
>> >> +static char *self_environ_file = "/proc/self/environ";
>> >
>> > Heh, no, that's not ok at all.
>> >
>> > This is a _huge_ sign that you are doing something wrong in your driver
>> > if you need something that isn't exported, or that you have to dig out
>> > of proc.
>> >
>> Lustre has a functionality that lets applications specify a global
>> jobid by setting the same environment variable across the cluster and
>> thus server can trace IO that is issued by different job. Currently it
>> is implemented by having a private version of cfs_access_process_vm
>> because access_process_vm is not exported. The patch intends to change
>> it to reading from proc. If we cannot dig it out from proc either, how
>> can we keep the functionality then? Please advise.
>
> Kernel code should not care about environment variables.  Just because
> you created a crazy requirement, does not mean it is a valid one, nor
> that I have to be the one to tell you how to implement it.
>
> I'm never going to take code that parses proc files, you all know better
> than that.
I see. I'll drop the patchset and keep the cfs_access_process_vm code
until better option is found.

Thanks,
Tao
