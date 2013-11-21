Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3KUBjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:39:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43587 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3KUBjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:39:20 -0500
Date: Thu, 21 Nov 2013 01:39:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com
Subject: Re: [PATCH v2] fs: binfmt_elf: Add ELF header consistency checks
Message-ID: <20131121013918.GI10323@ZenIV.linux.org.uk>
References: <1384994071-12283-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384994071-12283-1-git-send-email-geyslan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 09:34:31PM -0300, Geyslan G. Bem wrote:
> The member 'e_ehsize' that holds the ELF header size is compared
> with the elfhdr struct size. If not equal, goes out.
> If 'e_phoff' holds 0 the object has no program header table, so
> goes out.
> Ensures the file being loaded has the correct data encoding, checking
> 'e_ident[EI_DATA]' against 'ELF_DATA'.
> 
> Besides the checks being in accordance with the ELF Specifications,
> they increase the binary consistency reducing the use of malformed ones.

This is completely misguided.  We are allowed to reject such binaries,
but what's the point of doing that?
