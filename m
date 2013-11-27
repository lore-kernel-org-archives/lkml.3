Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3K0GOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:14:00 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:46881 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3K0GN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:13:59 -0500
MIME-Version: 1.0
In-Reply-To: <20131119071531.GA32469@gmail.com>
References: <20131118210436.233B5202A@prod-mail-relay06.akamai.com>
	<20131118143059.afe17d2faced16171a05eb10@linux-foundation.org>
	<20131119071531.GA32469@gmail.com>
Date: Wed, 27 Nov 2013 00:13:57 -0600
Message-ID: <CAMP44s19U3wJ5PdvqeoE=LX9R9dyV0t5P-1f9RN1hvn-yrNW1Q@mail.gmail.com>
Subject: Re: [PATCH v2] panic: Make panic_timeout configurable
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Baron <jbaron@akamai.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, ralf@linux-mips.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 1:15 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Mon, 18 Nov 2013 21:04:36 +0000 (GMT) Jason Baron <jbaron@akamai.com> wrote:
>>
>> > The panic_timeout value can be set via the command line option 'panic=x', or via
>> > /proc/sys/kernel/panic, however that is not sufficient when the panic occurs
>> > before we are able to set up these values. Thus, add a CONFIG_PANIC_TIMEOUT
>> > so that we can set the desired value from the .config.
>> >
>> > The default panic_timeout value continues to be 0 - wait forever, except for
>> > powerpc and mips, which have been defaulted to 180 and 5 respectively. This
>> > is in keeping with the fact that these arches already set panic_timeout in
>> > their arch init code. However, I found three exceptions- two in mips and one in
>> > powerpc where the settings didn't match these default values. In those cases, I
>> > left the arch code so it continues to override, in case the user has not changed
>> > from the default. It would nice if these arches had one default value, or if we
>> > could determine the correct setting at compile-time.
>>
>> Felipe is proposing a simpler patch ("panic: setup panic_timeout
>> early") which switches to early_param().  Is that sufficient for the
>> (undescribed!) failure which you are presumably observing?
>
> Also note that that patch is still incomplete: if panic_timeout is
> switched to early_param() then closely related functionality such as
> pause_on_oops should be moved early as well...

If that was the case, then whomever made the "oops" param generic sent
an incomplete patch because it's also early_param, and it's
interesting why you didn't have that problem with that patch, but you
do with this one.

-- 
Felipe Contreras
