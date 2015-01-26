Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbbAZQ4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:56:07 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58648 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbbAZQ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:56:04 -0500
MIME-Version: 1.0
In-Reply-To: <1421956345-1546-1-git-send-email-rydberg@bitmath.org>
References: <1421956345-1546-1-git-send-email-rydberg@bitmath.org>
Date: Mon, 26 Jan 2015 11:56:02 -0500
Message-ID: <CAN+gG=FNJ8O-=Q4kpsVSYYY+o3KLHpfm43OT-AgTPkHYF-zVLg@mail.gmail.com>
Subject: Re: [PATCH] Input: MT - Add support for balanced slot assignment
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 2:52 PM, Henrik Rydberg <rydberg@bitmath.org> wrote:
> Some devices are not fast enough to differentiate between a
> fast-moving contact and a new contact. This problem cannot be fully
> resolved because information is truly missing, but it is possible
> to safe-guard against obvious mistakes by restricting movement with
> a maximum displacement.
>
> The new problem formulation for dmax > 0 cannot benefit from the
> speedup for positive definite matrices, but since the convergence is
> faster, the result is about the same. For a handful of contacts, the
> latency difference is truly negligible.
>
> Suggested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Not-yet-signed-off-by: Henrik Rydberg <rydberg@bitmath.org>
> ---
> Hi Dmitry, Benjamin,
>
> This patch incorporates the notion of a speed limit in the slot
> assignment function, without changing the behavior for existing code.
>
> There are multi-touch movement cases where the difference between this
> algorithm and a simple deassign-overspeeding-contacts algorithm which
> warrants this approach. One example is when a whole array of contacts
> are moved one step to the right in one frame. With the simple
> algorithm, all contacts will be deassigned, whereas with this
> algorithm, the leftmost contact is deassigned and a new contact
> created on the right. This is the interpretation of smallest change,
> and is consistent with the behavior one would get from two contacts,
> for both algorithms.
>
> I have tested this on a number of testcases in my tree, and I am
> running the patch with a speed limit on my device as I write this. If
> this patch solves Benjamin's problem, I think we are ok.
>

Tested this morning, and yes, it solves the problem.
I assumed that the dmax was in mm, and used "10 * priv->x_res", which
seemed to do the trick:
- tapping with two fingers side by side triggered the jumps
- in the general case (switching from the index to the thumb to
click), the jumps disappeared.

Maybe we should also add a doc telling which units the dmax should be.

When you'll sign this, you can add my tested-by.

Cheers,
Benjamin
