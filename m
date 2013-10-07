Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3JGTED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:04:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57186 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3JGTD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:03:59 -0400
Date: Mon, 7 Oct 2013 20:03:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andre Richter <andre.o.richter@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: file_inode() vs f_mapping->host
Message-ID: <20131007190357.GA13318@ZenIV.linux.org.uk>
References: <CAKqeN29hu55Q0qXioaZKAppK-aA68rCaDUFg2z2AvUSEnnyMDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKqeN29hu55Q0qXioaZKAppK-aA68rCaDUFg2z2AvUSEnnyMDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 01:08:09PM +0200, Andre Richter wrote:
> Hi all,
> 
> in this thread ( https://lkml.org/lkml/2013/3/17/128 ), Al Viro argues
> that file_inode() is not equal to f_mapping->host in certain cases.
> 
> I'm asking, because in arch/x86/kernel/msr.c, msr_seek() retrieves the
> inode via f_mapping while one function later, msr_read() uses
> file_inode().
> Is this on purpose?

Both of those should use file_inode(), but in that case both expressions
yield the same value.  And no, it's not on purpose in case of msr.c -
just a historical accident.
