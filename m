Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbaGPI1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:27:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54194 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759487AbaGPI1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:27:14 -0400
Message-ID: <1405499224.5872.38.camel@marge.simpson.net>
Subject: Re: [PATCH 2/2 v2] sched: Rewrite per entity runnable load average
 tracking
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: bsegall@google.com
Cc: Yuyang Du <yuyang.du@intel.com>, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, pjt@google.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Date: Wed, 16 Jul 2014 10:27:04 +0200
In-Reply-To: <xm26pph6wmzy.fsf@sword-of-the-dawn.mtv.corp.google.com>
References: <1405293352-9305-1-git-send-email-yuyang.du@intel.com>
	 <1405293352-9305-3-git-send-email-yuyang.du@intel.com>
	 <xm26vbqzwx9a.fsf@sword-of-the-dawn.mtv.corp.google.com>
	 <20140715015105.GA2532@intel.com>
	 <xm26pph6wmzy.fsf@sword-of-the-dawn.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 10:27 -0700, bsegall@google.com wrote:

> It would still be good to see pipe_test numbers at various cgroup depths.

My t^Hcrusty ole box seems to be saying.. 

cgexec -g cpu:a pipe-test 1
3.16.0-default         5.016373 usecs/loop -- avg 5.021115 398.3 KHz
3.16.0-default+tim     5.003933 usecs/loop -- avg 4.986591 401.1 KHz

cgexec -g cpu:a/b pipe-test 1
3.16.0-default         5.543566 usecs/loop -- avg 5.565475 359.4 KHz
3.16.0-default+tim     5.663404 usecs/loop -- avg 5.647020 354.2 KHz

cgexec -g cpu:a/b/c pipe-test 1
3.16.0-default         6.092256 usecs/loop -- avg 6.094186 328.2 KHz
3.16.0-default+tim     6.311192 usecs/loop -- avg 6.299077 317.5 KHz

..that 0 KHz will become easier to achieve.

