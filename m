Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaDOMHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:07:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33859 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbaDOMHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:07:41 -0400
Date: Tue, 15 Apr 2014 14:07:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: dri-devel@lists.freedesktop.org, Alex Deucher <alexander.deucher@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: 15-rc1: radeon modesetting fails
Message-ID: <20140415120740.GA8306@nazgul.tnic>
References: <20140415070204.GA4806@pd.tnic>
 <534CFBD7.3070604@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <534CFBD7.3070604@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On Tue, Apr 15, 2014 at 11:28:55AM +0200, Christian König wrote:
> Hi Borislav,
> 
> that's a known issue and should be fixed in the next rc, see this
> bugreport: https://bugs.freedesktop.org/show_bug.cgi?id=77009
> 
> You might also want to try my branch with 3.15 fixes which includes
> the necessary patch for this: http://cgit.freedesktop.org/~deathsimple/linux/log/?h=drm-fixes-3.15-wip
> 
> Let me know if that branch works for you or not.

so I went and merged your branch as you suggested. Btw, on its tip it
has:

commit ec02666dd0791312b5820e1a9a023681d99d07ec
Author: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Date:   Tue Mar 18 17:16:52 2014 +0100

    drm/radeon: memory leak on bo reservation failure. v2

(just checking whether I got the right one)

and, unfortunately, no change - same problem. Let me know if I should
bisect the subset of 59 radeon patches which went in during the merge
window...

Btw, just in case, I went and updated radeon firmware in
/lib/firmware/radeon/ from upstream but it didn't change anything.

Thanks.
