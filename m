Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaDVL0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:26:24 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35301 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbaDVL0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:26:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140422111906.GD17116@hmsreliant.think-freely.org>
References: <1398144722-9864-1-git-send-email-nasa4836@gmail.com> <20140422111906.GD17116@hmsreliant.think-freely.org>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 19:25:41 +0800
Message-ID: <CAHz2CGWfwx+SOTurpW2fO4LsB08tp2ANw+k6aa6bGL=15LNScQ@mail.gmail.com>
Subject: Re: [PATCH] netprio_cgroup: explicitly init the early_init field
To: Neil Horman <nhorman@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        daniel.wagner@bmw-carit.de, gaofeng@cn.fujitsu.com,
        stephen@networkplumber.org,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 7:19 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> NACK, for the same reason that it doesn't make sense for net_classid.
> Early_init should already be zero.  What problem are you trying to solve here?

Hi, Neil,

I'm sorry I should have made this more clear.

Sure, for this global variable struct, if not initailized, its all
fields will be initialized
to 0 or null(depending on its type).  The point here is no to deprive
the rights of compiler/linker of doing this initialization, it is mainly for
documentation reason. Actually this field's value would affect how ->css_alloc
should implemented.

Concretely, if early_init is nonzero, then ->css_alloc *must not* call kzalloc,
because in cgroup implementation, ->css_alloc will be called earlier before
mm_init().

I don't think that the value of one field(early_init) has a so subtle
restrition on the another field(css_alloc) is a good thing, but since
it is there, docment it should be needed.

Thanks,
Jianyu Zhan
