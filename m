Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbbAJMJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 07:09:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:35374 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbbAJMJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 07:09:33 -0500
X-AuditID: cbfee61a-f79c06d000004e71-1c-54b1167c7c6d
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <009401d0297a$41523580$c3f6a080$@samsung.com>
 <20150106194419.GB54001@jaegeuk-mac02>
In-reply-to: <20150106194419.GB54001@jaegeuk-mac02>
Subject: RE: [f2fs-dev][PATCH 2/2] f2fs: enable recover_xattr_data to avoid cp
 when fsync after operating xattr
Date: Sat, 10 Jan 2015 20:08:33 +0800
Message-id: <000101d02cce$4bed1c60$e3c75520$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGwcrxFvM/bD0iZoRVUq2UPSe0nQwFF+kkanOkhlnA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9jQd0asY0hBsv3iFlc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4+Dxi6wF
	H7krvv7Lb2A8zNnFyMkhIWAiMW35LTYIW0ziwr31QDYXh5DAdEaJm1unsUM4Pxglrh95DFbF
	JqAisbzjPxOILSKgJtG7bwqQzcHBLFAksWqFAEhYSCBJ4tv8V6wgNqeAscSHx5fYQEqEBQol
	jnwTBAmzCKhKbO9aADaFV8BS4sfZm+wQtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8ZYa4U0Fi
	x9nXjBAXWEkcnHWFHaJGXGLjkVssExiFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRnD4P5PawbiyweIQowAHoxIP74/ODSFCrIllxZW5hxglOJiVRHil7gCF
	eFMSK6tSi/Lji0pzUosPMUpzsCiJ8yrZt4UICaQnlqRmp6YWpBbBZJk4OKUaGEtLmm3a7I8c
	j/LweXki9taF3cbOZquljnz8/eWPy22BD/ycp5/GbxZ6c6ssOtz0BduGxunF8d7La56W6WtY
	Gp74/aPZp1f14SqtjwV7lkue7eiQVnSM23zSretGv9zLiHOl+g86vVaZyvF8ZWH8mXf+WHMS
	570VXwoWX+IqOz/954mZDJ3fNiqxFGckGmoxFxUnAgBcYDVvewIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, January 07, 2015 3:44 AM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: enable recover_xattr_data to avoid cp when fsync after
> operating xattr
> 
> Hi Chao,
> 
> On Tue, Jan 06, 2015 at 02:29:40PM +0800, Chao Yu wrote:
> > Now if we call fsync() after we update the xattr date belongs to the file, f2fs
> > will do checkpoint to keep data.
> > This can cause low performance because checkpoint block most operation and write
> > lots of blocks. So we'd better to avoid doing checkpoint by writing modified
> > xattr node page to warm node segment, and then it can be recovered when we mount
> > this device later on.
> 
> You're trying to change the writing policy as xattr blocks are written into
> WARM_NODE area instead of COLD_NODE area.
> I don't think xattrs are frequently changed between each fsync calls.
> 
> How do you think?

I'm not sure whether there is a scenario that setxattr and fsync are invoked
alternately, but if there is, our performance will decrease obviously.

If you don't want to change writing policy, how about writing xattr node with
fsync flag into cold node segment when fsync() is called, then try to recover
it from cold node chain when recovery after abnormally pow-cut, this way can
avoid cp frequently in above scenario.

Thanks,
Yu


