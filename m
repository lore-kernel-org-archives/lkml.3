Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaEFQ7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:59:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45636 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaEFQ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:59:04 -0400
Date: Tue, 6 May 2014 17:59:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: IMA & truncate
Message-ID: <20140506165901.GS18016@ZenIV.linux.org.uk>
References: <5368E46B.9050708@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5368E46B.9050708@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 04:32:27PM +0300, Dmitry Kasatkin wrote:
> Hi,
> 
> I have discovered one IMA related issue.
> 
> IMA file hash is re-calculate if needed on file close.
> 
> It works with ftruncate(fd, length) syscall, because it operates on
> "opened" file.
> Recalculation is happening on file close.
> 
> truncate(path, length) syscall works with path and no file open/close
> takes place.
> Recalculation does not happen.
> IMA denies file access later.
> 
> It looks like vfs_truncate() should possibly call IMA to recalculate the
> hash.

Who said that it has permissions to read the file?  Reread truncate(2)
manpage; it requires the file to be *writable* for caller, but it doesn't
need it to be readable.
