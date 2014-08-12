Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaHLVlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:41:15 -0400
Received: from mta-out1.inet.fi ([62.71.2.193]:48525 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbaHLVlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:41:14 -0400
Date: Wed, 13 Aug 2014 00:40:51 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Oren Twaig <oren@scalemp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: x86: vmalloc and THP
Message-ID: <20140812214051.GA17497@node.dhcp.inet.fi>
References: <53E99F86.5020100@scalemp.com>
 <20140812060745.GA7987@node.dhcp.inet.fi>
 <53EA3EE4.6090100@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EA3EE4.6090100@scalemp.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 07:20:52PM +0300, Oren Twaig wrote:
> >What's the point to use vmalloc() in this case?
> I've noticed that some lock/s are using linear addresses which are
> located at 0xffffc901922b4500 and from what I understand
> from mm.txt (kernel 3.0.101):
> *ffffc90000000000 - ffffe8ffffffffff (=45 bits) vmalloc/ioremap space
> 
> *So I'm not sure who/how/why this lock got allocated there, but obviously
> it is using that linear set. No ?

It would be nice to know what lock it was, but nothing is inherently wrong
with lock in vmalloc space.

-- 
 Kirill A. Shutemov
