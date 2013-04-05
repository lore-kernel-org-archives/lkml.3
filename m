Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162842Ab3DEVVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:21:18 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33519 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162207Ab3DEVVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:21:13 -0400
Date: Fri, 5 Apr 2013 14:21:10 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: NeilBrown <neilb@suse.de>, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: bcache: BUG in fuzz testing without devices
Message-ID: <20130405212110.GD15749@google.com>
References: <515B056E.6010002@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515B056E.6010002@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 12:21:02PM -0400, Sasha Levin wrote:
> Hi all,
> 
> It seems that trying to fuzz bcache without any devices triggers a BUG:
> 
> That BUG looks very intentional there, any reason for adding it instead of exiting
> if there aren't any devices?

The fuzz tester is meant to stress test some of the btree code - it's a
purely in memory test. But it looks like it's rotted - thanks for the
bug report, I'll disable it for now.
