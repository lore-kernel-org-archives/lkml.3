Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680Ab3DDNU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:20:59 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59248 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760571Ab3DDNU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:20:56 -0400
Date: Thu, 4 Apr 2013 09:20:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-ID: <20130404132048.GB4756@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130404104319.42d97a8ad7badf00af7ef1e0@canb.auug.org.au>
 <alpine.LFD.2.00.1304041516160.30499@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1304041516160.30499@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 03:18:32PM +0200, Lukáš Czerner wrote:
> I am afraid I do not understand why this is happening. The commit
> simply replaces ext4_get_group_no_and_offset() with
> ext4_get_group_number() which has the similar definition in the same
> header file. Maybe someone knows what this is all about ?

I've fixed this up already in the ext4 tree.  The problem is that you
defined the function ext4_get_group_number() as "inline", but the
function body was only in fs/ext4/balloc.c.  I have no idea why gcc
wasn't complaining about this on x86, but the fix was to simply
declare the function as "extern", not as "inline".

						- Ted
