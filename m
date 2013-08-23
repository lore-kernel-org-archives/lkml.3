Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3HWUFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:05:25 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:46404 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3HWUFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:05:22 -0400
Date: Fri, 23 Aug 2013 16:05:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [guv 00/16] [RFC] percpu: Replace __get_cpu_var uses throughout
 the kernel
Message-ID: <20130823200514.GA11391@mtj.dyndns.org>
References: <00000140ac8debd6-6f9e64f9-1107-4336-91ef-77cdf764b96a-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140ac8debd6-6f9e64f9-1107-4336-91ef-77cdf764b96a-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Fri, Aug 23, 2013 at 07:01:56PM +0000, Christoph Lameter wrote:
> This patch converts __get_cpu_var into either and explicit address
> calculation using this_cpu_ptr() or into a use of this_cpu
> operations that use the offset. Thereby address calcualtions are
> avoided and less registers are used when code is generated.

Yeah, we should have done this long ago.  Eventually, I think we'd be
better off dropping all _var() accessors.  They were okay when we had
segration between static and dynamic ones but are now just adding to
confusion.

On a cursory scan,

* Each patch probably needs a brief explanation of why this is
  happening, especially if these patches are gonna be routed
  separately.

* It would be a lot easier to route the patches if each had cc's to
  the maintainers of the affected subsystems.

* Dunno what's the convention around conccinelle scripts but do we
  need to keep them around if the accessor being converted gets
  removed at the end of the series?

How do you want to route the patches?  I'm gonna apply the second
patch which updates __verify_pcpu_ptr() to the percpu tree right away
and push it to Linus early during the merge window so that pushing
other patches through different trees from there on isn't too painful.

Thanks.

-- 
tejun
