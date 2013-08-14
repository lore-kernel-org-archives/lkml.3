Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244Ab3HNXie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:38:34 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:46639 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab3HNXic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:38:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130814230648.GD22316@thunk.org>
References: <520BB9EF.5020308@linux.intel.com> <20130814194359.GA22316@thunk.org>
 <520BED7A.4000903@intel.com> <20130814230648.GD22316@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Aug 2013 16:38:12 -0700
Message-ID: <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, david@fromorbit.com,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 4:06 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Aug 14, 2013 at 01:50:02PM -0700, Dave Hansen wrote:
>>
>> Would a plain old fallocate() do the trick, or does it actually need
>> zeros written to it?
>
> It would be better to write zeros to it, so we aren't measuring the
> cost of the unwritten->written conversion.

At the risk of beating a dead horse, how hard would it be to defer
this part until writeback?

--Andy
