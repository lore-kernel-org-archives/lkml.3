Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbaEMHc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:32:56 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:47177 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaEMHcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:32:54 -0400
MIME-Version: 1.0
In-Reply-To: <5370E4B4.1060802@oracle.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1399552888-11024-3-git-send-email-kirill.shutemov@linux.intel.com>
 <20140508145729.3d82d2c989cfc483c94eb324@linux-foundation.org> <5370E4B4.1060802@oracle.com>
From: Armin Rigo <arigo@tunes.org>
Date: Tue, 13 May 2014 09:32:13 +0200
X-Google-Sender-Auth: Q0GhWn4uwckW03D_dzQR5p0L4Kg
Message-ID: <CAMSv6X0yg4haVtUifFrdkCCZjJV-TLXJ-KsiCPiBue0Y0qNTcQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: replace remap_file_pages() syscall with emulation
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

On 12 May 2014 17:11, Sasha Levin <sasha.levin@oracle.com> wrote:
> Since we can't find any actual users,

The PyPy project doesn't count as an "actual user"?  It's not just an
idea in the air.  It's beta code that is already released (and open
source):

http://morepypy.blogspot.ch/2014/04/stm-results-and-second-call-for.html

The core library is available from there (see the test suite in c7/test/):

https://bitbucket.org/pypy/stmgc

I already reacted to the discussion here by making remap_file_pages()
optional (#undef USE_REMAP_FILE_PAGES) but didn't measure the
performance impact of this, if any (I expect it to be reasonable).
Still, if you're looking for a real piece of code using
remap_file_pages(), it's one.


A bientôt,

Armin.
