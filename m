Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaGUCin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:38:43 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53828 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaGUCim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:38:42 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, masami.hiramatsu.pt@hitachi.com,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 1/3] perf/sdt : Listing of SDT markers by perf
References: <20140717054826.19995.61782.stgit@hemant-fedora>
	<20140717055341.19995.97042.stgit@hemant-fedora>
	<87d2d24kui.fsf@tassilo.jf.intel.com>
Date: Mon, 21 Jul 2014 11:38:40 +0900
In-Reply-To: <87d2d24kui.fsf@tassilo.jf.intel.com> (Andi Kleen's message of
	"Fri, 18 Jul 2014 10:50:45 -0700")
Message-ID: <87zjg3jv0v.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, 18 Jul 2014 10:50:45 -0700, Andi Kleen wrote:
> Hemant Kumar <hemant@linux.vnet.ibm.com> writes:
>> +/*
>> + * Finds out the libraries present in a system as shown by the command
>> + * "ldconfig --print-cache". Uses "=>" and '/' to find out the start of a
>> + * dso path.
>> + */
>
> This seems like a hack. How would that handle chroot, containers
> etc. ?

[SNIP]
>> +/*
>> + * Obtain the list of paths from the PATH env variable
>> + */
>
> Same as above. This probably needs to be more configurable to handle
> more ways to find binaries.

Agreed.  What about not to be smart?  IOW, just let users specify
directories and/or files to be scanned.  Maybe we can use it like:

  perf list sdt --scan $PATH

or

  perf sdt-cache --scan /lib:/lib64


We can add some wrapper or default directory later if needed.


Thanks,
Namhyung
