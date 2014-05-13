Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbaEMM6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:58:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47916 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759817AbaEMM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:58:19 -0400
Message-ID: <537216C5.7050204@oracle.com>
Date: Tue, 13 May 2014 08:57:41 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Armin Rigo <arigo@tunes.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@kernel.org
Subject: Re: [PATCH 2/2] mm: replace remap_file_pages() syscall with emulation
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com> <1399552888-11024-3-git-send-email-kirill.shutemov@linux.intel.com> <20140508145729.3d82d2c989cfc483c94eb324@linux-foundation.org> <5370E4B4.1060802@oracle.com> <CAMSv6X0yg4haVtUifFrdkCCZjJV-TLXJ-KsiCPiBue0Y0qNTcQ@mail.gmail.com>
In-Reply-To: <CAMSv6X0yg4haVtUifFrdkCCZjJV-TLXJ-KsiCPiBue0Y0qNTcQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 03:32 AM, Armin Rigo wrote:
> Hi Sasha,
> 
> On 12 May 2014 17:11, Sasha Levin <sasha.levin@oracle.com> wrote:
>> Since we can't find any actual users,
> 
> The PyPy project doesn't count as an "actual user"?  It's not just an
> idea in the air.  It's beta code that is already released (and open
> source):
> 
> http://morepypy.blogspot.ch/2014/04/stm-results-and-second-call-for.html
> 
> The core library is available from there (see the test suite in c7/test/):
> 
> https://bitbucket.org/pypy/stmgc
> 
> I already reacted to the discussion here by making remap_file_pages()
> optional (#undef USE_REMAP_FILE_PAGES) but didn't measure the
> performance impact of this, if any (I expect it to be reasonable).
> Still, if you're looking for a real piece of code using
> remap_file_pages(), it's one.

Oh, I don't have anything against PyPy, I just wasn't aware it used
remap_file_pages() (I think I've missed the discussion in the parallel
thread).

Indeed it is a user, have you tried it with a kernel that is running
Kirill's patch set to replace remap_file_pages()?


Thanks,
Sasha

