Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaEFSkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:40:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55612 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaEFSkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:40:18 -0400
Message-ID: <1399401557.9468.21.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: IMA & truncate
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 06 May 2014 14:39:17 -0400
In-Reply-To: <20140506165901.GS18016@ZenIV.linux.org.uk>
References: <5368E46B.9050708@samsung.com>
	 <20140506165901.GS18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050618-0928-0000-0000-000001B19D3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-06 at 17:59 +0100, Al Viro wrote: 
> On Tue, May 06, 2014 at 04:32:27PM +0300, Dmitry Kasatkin wrote:
> > Hi,
> > 
> > I have discovered one IMA related issue.
> > 
> > IMA file hash is re-calculate if needed on file close.
> > 
> > It works with ftruncate(fd, length) syscall, because it operates on
> > "opened" file.
> > Recalculation is happening on file close.
> > 
> > truncate(path, length) syscall works with path and no file open/close
> > takes place.
> > Recalculation does not happen.
> > IMA denies file access later.
> > 
> > It looks like vfs_truncate() should possibly call IMA to recalculate the
> > hash.
> 
> Who said that it has permissions to read the file?  Reread truncate(2)
> manpage; it requires the file to be *writable* for caller, but it doesn't
> need it to be readable.

Al, you're not going to like this, but ima_calc_file_hash() calls
ima_calc_file_hash_tfm(), which already sets/unsets FMODE_READ in order
to calculate the file hash.

Mimi

