Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbbABSOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:14:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33234 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbABSOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:14:20 -0500
Date: Fri, 2 Jan 2015 18:14:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, James Hogan <james.hogan@imgtec.com>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: parisc: kernel: sys_parisc:  Remove some unused
 functions
Message-ID: <20150102181408.GT22149@ZenIV.linux.org.uk>
References: <1420222190-32621-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420222190-32621-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 07:09:50PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> parisc_personality() parisc_fallocate() parisc_sync_file_range()
> parisc_fadvise64_64() parisc_readahead() parisc_pwrite64() parisc_pread64()
> parisc_ftruncate64() parisc_truncate64()
> 
> This was partially found by using a static code analysis program called cppcheck.

... which program has ended up missing
#define ENTRY_OURS(_name_) .word parisc_##_name_
and tons of lines like this
        ENTRY_OURS(sync_file_range)
in arch/parisc/kernel/syscall_table.S
