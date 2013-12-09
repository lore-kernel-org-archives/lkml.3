Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab3LINtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:49:42 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:41274 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3LINth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:49:37 -0500
MIME-Version: 1.0
In-Reply-To: <20131209111900.GC6562@kroah.com>
References: <1386583012-506-1-git-send-email-ethan.kernel@gmail.com>
	<20131209111900.GC6562@kroah.com>
Date: Mon, 9 Dec 2013 21:49:36 +0800
Message-ID: <CABawtvNZn8VPjP-Bs3Zw9HJw134iZRx8dWbGgPbWFA4CyJjsZA@mail.gmail.com>
Subject: Re: [PATCH v3] xen/debugfs: Check debugfs initialization before using it
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: konrad.wilk@oracle.com, raghavendra.kt@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 7:19 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Dec 09, 2013 at 05:56:52PM +0800, Ethan Zhao wrote:
>> From: "ethan.zhao" <ethan.kernel@gmail.com>
>>
>> Should check debugfs initialization with debugfs_initialized() before using it,
>> Because if it isn't initialized, the return value of fake debugfs_create_dir() etc
>> functions would be ERR_PTR(-ENODEV), checking with NULL will not work.
>>
>> V3: add warning message when debugfs not configured or disabled.
>
> That's not what this patch does...
>
>> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
>> ---
>>  arch/x86/xen/debugfs.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/x86/xen/debugfs.c b/arch/x86/xen/debugfs.c
>> index c8377fb..85c0e0e 100644
>> --- a/arch/x86/xen/debugfs.c
>> +++ b/arch/x86/xen/debugfs.c
>> @@ -9,12 +9,18 @@ static struct dentry *d_xen_debug;
>>
>>  struct dentry * __init xen_init_debugfs(void)
>>  {
>> +     if (!debugfs_initialized()) {
>> +             d_xen_debug = NULL;
>> +             goto nodebugfs;
>> +     }
>
> Again, why is this even needed?
>
> What problem in the existing code are you trying to solve?
>
What I want to ask who is so smart and fake some many functions when
CONFIG_DEBUG_FS is not configured/defined and the build could pass
without any error ? What is the motive make him wrote some many fake
function and why he wrote the debugfs_initialized() function seem
'useless' at all ?

Thanks,
Ethan
