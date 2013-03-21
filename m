Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3CUCuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 22:50:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52931 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3CUCut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 22:50:49 -0400
Date: Thu, 21 Mar 2013 11:50:41 +0900 (JST)
Message-Id: <20130321.115041.225288996.d.hatayama@jp.fujitsu.com>
To: ebiederm@xmission.com, vgoyal@redhat.com
Cc: cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 01/21] vmcore: reference e_phoff member explicitly
 to get position of program header table
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <87ppyvnjyn.fsf@xmission.com>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040053.15064.93652.stgit@localhost6.localdomain6>
	<87ppyvnjyn.fsf@xmission.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v3 01/21] vmcore: reference e_phoff member explicitly to get position of program header table
Date: Tue, 19 Mar 2013 14:44:16 -0700

> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
> 
>> Currently, the code assumes that position of program header table is
>> next to ELF header. But future change can break the assumption on
>> kexec-tools and the 1st kernel. To avoid worst case, reference e_phoff
>> member explicitly to get position of program header table in
>> file-offset.
> 
> In principle this looks good.  However when I read this it looks like
> you are going a little too far.
> 
> You are changing not only the reading of the supplied headers, but
> you are changing the generation of the new new headers that describe
> the data provided by /proc/vmcore.
> 
> I get lost in following this after you mangle merge_note_headers.
> 
> In principle removing silly assumptions seems reasonable, but I think
> it is completely orthogonal to the task of maping vmcore mmapable.
> 
> I think it is fine to claim that the assumptions made here in vmcore are
> part of the kexec on panic ABI at this point, which would generally make
> this change unnecessary.

This was suggested by Vivek. He prefers generic one.

Vivek, do you agree to this? Or is it better to re-post this and other
clean-up patches as another one separately to this patch set?

Thanks.
HATAYAMA, Daisuke

