Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaCZASz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:18:55 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53192 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaCZASx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140325200352.GU31785@oranje.fc.hp.com>
References: <1390946045-2769-1-git-send-email-yinghai@kernel.org>
	<20140325200352.GU31785@oranje.fc.hp.com>
Date: Tue, 25 Mar 2014 17:18:53 -0700
X-Google-Sender-Auth: sUwcJP8uacLJ4CMGsDxgU_e3HMk
Message-ID: <CAE9FiQUxBWFfUBjdsakPV0B=rsB4wD-sX6Q2tVbOjNy9RJffRg@mail.gmail.com>
Subject: Re: [PATCH v3] x86, irq: get correct available vectors for cpu disable
From: Yinghai Lu <yinghai@kernel.org>
To: Linn Crosetto <linn@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 1:03 PM, Linn Crosetto <linn@hp.com> wrote:
> Thanks for the patch.
>
> On Tue, Jan 28, 2014 at 01:54:05PM -0800, Yinghai Lu wrote:
>> used_vectors is a bitmap for vectors that are not tracked in per_cpu
>> vector_irq.
>
> I feel like this comment (also in the code) could be misleading because vectors
> above first_system_vector are effectively not tracked in per_cpu vector_irq, but
> also may not have the bit set in used_vectors. For example, used_vectors from a
> system that I am looking at now:
>
> first_system_vector
>                 239                  255
>                   |                  |
>                   10 01000 11111 11111
>
> test_bit(240, used_vectors) does not return the correct answer to the question
> about whether the vector is tracked in per_cpu vector_irq. This leads to two
> meanings for the bitmap; for vectors less than first_system_vector whether or
> not they are tracked in per_cpu vector_irq, and for vectors above
> first_system_vector, whether or not they are in use:
>
> static inline int is_per_cpu_vector(int vector) {
>         return !test_bit(vector, used_vectors) &&
>                         vector < first_system_vector;
> }

sorry, I can not catch what you want to say.

Do you mean the change log or comment in the patch is not right?

Thanks

Yinghai
