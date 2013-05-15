Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab3EORKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:10:55 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:57232 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932925Ab3EORKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:10:54 -0400
References: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com> <20130510045049.GU24635@dastard> <CAEsagEism-SQB9LRC+EuPLoBiFOEHc0peLjh3cDxwrNe3Jz=2w@mail.gmail.com> <20130511212608.GA26298@thunk.org> <CAEsagEiFWxnLXWu7dH7jfH7xd4cRVaUdJr4zB+Rkk7V1kEemmA@mail.gmail.com> <35557711-A88D-4226-B3C6-3787573F5403@dilger.ca> <CAEsagEhwKDNiENPVa4C+LvXOViMrkVz_prsDyUn8_J=VuToqMA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <CAEsagEhwKDNiENPVa4C+LvXOViMrkVz_prsDyUn8_J=VuToqMA@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <97A34425-E663-4322-BEFF-6426C54572F9@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tux3@tux3.org" <tux3@tux3.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
X-Mailer: iPhone Mail (10B146)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Tux3 Report: Faster than tmpfs, what?
Date: Wed, 15 May 2013 11:10:52 -0600
To: Daniel Phillips <daniel.raymond.phillips@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-05-14, at 0:25, Daniel Phillips <daniel.raymond.phillips@gmail.com> wrote:
> Interesting, Andreas. We don't do anything as heavyweight as
> allocating an inode in this path, just mark the inode dirty (which
> puts it on a list) and set a bit in the inode flags.

The new inode allocation is only needed for the truncate-to-zero case. If the inode is being deleted it is used directly. 

Sorry for confusion, it has been a long time since I looked at that code. 

Cheers, Andreas