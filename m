Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbaLEAyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 19:54:08 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43358 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbaLEAyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 19:54:05 -0500
Date: Thu, 4 Dec 2014 16:54:01 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: linux-next: Tree for Dec 4
Message-ID: <20141205005401.GA1279@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Theodore Ts'o <tytso@mit.edu>
References: <20141204195928.4a5b93f4@canb.auug.org.au>
 <20141204233411.GA1223@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204233411.GA1223@hudson.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all,

On Thu, Dec 04, 2014 at 03:34:11PM -0800, Jeremiah Mahler wrote:
> all,
> 
> On Thu, Dec 04, 2014 at 07:59:28PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20141203:
> > 
[...]
> > 
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> [...]
> 
> linux-next 20141204 is broken on all my machines, 20141203 worked fine.
> 
> They fail very early in the boot process and are unable to mount root.
> There are lots of "ext4_check_descriptors: Checksum for group ...
> failed" messages.
> 
> Any suggestions for where to start looking?
> 
> -- 
> - Jeremiah Mahler

I ran a bisect and found this patch to be faulty.

  commit fdfe073987619ec375da8d8a2701ab271d1b1339
  Author: Dmitry Monakhov <dmonakhov@openvz.org>
  Date:   Tue Dec 2 16:09:16 2014 -0500
  
      ext4: fix potential use after free during resize
      
      We need some sort of synchronization while updating ->s_group_desc
      because there are a lot of users which can access old ->s_group_desc
      array after it was released.
      
      Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
      Signed-off-by: Theodore Ts'o <tytso@mit.edu>

-- 
- Jeremiah Mahler
