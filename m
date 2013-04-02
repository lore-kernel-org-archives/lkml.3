Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab3DBK56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:57:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40919 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab3DBK54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:57:56 -0400
Message-ID: <1364900274.18374.21.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        daniel.vetter@ffwll.ch, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-media@vger.kernel.org
Date: Tue, 02 Apr 2013 12:57:54 +0200
In-Reply-To: <20130228102502.15191.14146.stgit@patser>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 11:25 +0100, Maarten Lankhorst wrote:
> +struct ticket_mutex {
> +       struct mutex base;
> +       atomic_long_t reservation_id;
> +};

I'm not sure this is a good name, esp. due to the potential confusion
vs the ticket spinlocks we have. 

