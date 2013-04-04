Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763267Ab3DDQjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:39:51 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52413
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762468Ab3DDQjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:39:49 -0400
Message-ID: <1365093584.2609.110.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, daniel.vetter@ffwll.ch, x86@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org
Date: Thu, 04 Apr 2013 18:39:44 +0200
In-Reply-To: <20130404133123.GW2228@phenom.ffwll.local>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
	 <1364900432.18374.24.camel@laptop> <515AF1C1.7080508@canonical.com>
	 <1364921954.20640.22.camel@laptop> <1365076908.2609.94.camel@laptop>
	 <20130404133123.GW2228@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
> The trick with the current code is that the oldest task
> will never see an -EAGAIN ever and hence is guaranteed to make forward
> progress. If the task is really unlucky though it might be forced to
> wait
> for a younger task for every ww_mutex it tries to acquire.

Agreed on that.. while I didn't state this my proposed thing should
behave the same. It follows from the symmetry breaking in that only
younger tasks can get 'kill'ed.

