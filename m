Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081Ab3CHNdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:33:00 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:34088 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3CHNc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:32:58 -0500
From: "Ma, Jingbai (Kingboard)" <kingboard.ma@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Vivek Goyal <vgoyal@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "kumagai-atsushi@mxc.nes.nec.co.jp" 
	<kumagai-atsushi@mxc.nes.nec.co.jp>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel
 to speedup kernel dump process
Thread-Topic: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel
 to speedup kernel dump process
Thread-Index: AQHOG0RBYIn9YC/DLUqIK7z+kk7MipiaWEAAgAE6bYCAAAeQgIAAt+mA
Date: Fri, 8 Mar 2013 13:31:51 +0000
Message-ID: <CD6006EB.36EC%kingboard.ma@hp.com>
In-Reply-To: <5139BE7F.5020905@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.1.130117
x-originating-ip: [15.201.58.29]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA1383B8AC63C845BC9B29552C0C764C@Compaq.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/13 6:33 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:


>On 03/08/2013 02:06 AM, Jingbai Ma wrote:
>> 
>> Kernel do have some abilities that user space haven't. It's possible to
>> map whole memory space of the first kernel into user space on the second
>> kernel. But the user space code has to re-implement some parts of the
>> kernel memory management system again. And worse, it's architecture
>> dependent, more architectures supported, more codes have to be
>> implemented. All implementation in user space must be sync to kernel
>> implementation. It's may called "flexibility", but it's painful to
>> maintain the codes.
>> 
>
>What?  You are basically talking about /dev/mem... there is nothing
>particularly magic about it at all.

What we are talking about is filtering memory pages (AKA memory pages
classification)
The makedumpfile (or any other dumper in user space) has to know the
exactly
memory layout of the memory management data structures, it not only
architecture dependent, but also may varies in different kernel release.
At this point, /dev/mem doesn't give any help.
So IMHO, I would like to do it in kernel, rather than So keep tracking
changes in user space code.

>
>	-hpa
>
>-- 
>H. Peter Anvin, Intel Open Source Technology Center
>I work for Intel.  I don't speak on their behalf.
>

