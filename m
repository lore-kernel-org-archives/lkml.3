Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaGBPCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:02:40 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:33900 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaGBPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:02:38 -0400
Date: Wed, 2 Jul 2014 11:02:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Binder Makin <merimus@google.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Daniel Jacobowitz <dmj@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: [RFC] cgroups: Resource controller for open files.
Message-ID: <20140702150234.GD23275@htj.dyndns.org>
References: <1404311407-4851-1-git-send-email-merimus@google.com>
 <20140702143300.GB23275@htj.dyndns.org>
 <CAANmLtwwbKBi+zZ01ywbeMnzu5a0UvqEz-_zHJLNtBVso2=ibg@mail.gmail.com>
 <20140702144901.GC23275@htj.dyndns.org>
 <CAANmLtwQkwrfQK0QK5LZSGqw7Z2+L-CSC_5TuSko1QtYo8WFfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAANmLtwQkwrfQK0QK5LZSGqw7Z2+L-CSC_5TuSko1QtYo8WFfQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 10:55:01AM -0400, Binder Makin wrote:
> It does allow processes which are used to handling file handled to deal
> with the situation more cleanly.
> If you get the ENOMEM then you are out of memory and you kill the process,
> but if you are out of file handles we can clean up the open handles and
> continue.

I don't know.  If the program can manage fds dynamically, it may as
well police itself under a sensible limit.  I get that programs which
already work with EMFILE may benefit from this but this isn't adding
any essential feature and the same goal can be trivially achieved
without any help from kernel as the benefits from EMFILE handling
assumes the program is well-behaving.  I'm very doubtful that
custom-fitting kernel behavior to specific and rather peculiar program
behaviors is a healthy approach.

Thanks.

-- 
tejun
