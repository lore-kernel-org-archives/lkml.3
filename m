Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096Ab3AOXPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:15:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933709Ab3AOXPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:15:34 -0500
Date: Tue, 15 Jan 2013 18:15:30 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        zohar@linux.vnet.ibm.com, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com
Subject: Re: [PATCH 0/3] ELF executable signing and verification
Message-ID: <20130115231530.GB18802@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
 <CAFLxGvxWs79ZCigDtBfkdu0mMk8Cfm6xNzzPZkoPKT9pTc9zrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvxWs79ZCigDtBfkdu0mMk8Cfm6xNzzPZkoPKT9pTc9zrA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 11:27:12PM +0100, richard -rw- weinberger wrote:
> On Tue, Jan 15, 2013 at 10:34 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Upon exec(), we determine if executable is signed. If it is, then locks
> > down the pages in memory (using MAP_LOCKED) and verfies the signature.
> > If signature does not match, process is killed. Unsigned processes
> > don't get affected at all.
> 
> Also ptrace() should be disallowed on such a process created from a signed ELF.

Yes, that I have listed in TODO. We need to disable ptrace for signed
processes or make sure only signed process can trace it.

Thanks
Vivek
