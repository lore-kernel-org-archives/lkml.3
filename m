Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaHNRfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:35:20 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:55963 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaHNRfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:35:18 -0400
MIME-Version: 1.0
In-Reply-To: <532c68b54b1894b9da1d9807701872cab28f8a70.1407994704.git.luto@amacapital.net>
References: <cover.1407994704.git.luto@amacapital.net> <532c68b54b1894b9da1d9807701872cab28f8a70.1407994704.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 14 Aug 2014 10:34:56 -0700
Message-ID: <CALCETrWOxGLG=iUvPD5jGWoS+jHA97N2D1t=Vivmyq3TEJGZvA@mail.gmail.com>
Subject: Re: [PATCH v6 2/7] random, timekeeping: Collect timekeeping entropy
 in the timekeeping code
To: kvm list <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Honig <ahonig@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:43 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Currently, init_std_data calls ktime_get_real().  This imposes
> awkward constraints on when init_std_data can be called, and
> init_std_data is unlikely to collect the full unpredictable data
> available to the timekeeping code, especially after resume.
>
> Remove this code from random.c and add the appropriate
> add_device_randomness calls to timekeeping.c instead.

*sigh* this is buggy:


> +       add_device_randomness(tk, sizeof(tk));

sizeof(*tk)

> +       add_device_randomness(tk, sizeof(tk));

ditto.

I'll fix this for v7, but I'll wait awhile for other comments to reduce spam.

--Andy
