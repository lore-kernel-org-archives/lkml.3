Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3HADsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 23:48:33 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33530 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3HADsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 23:48:32 -0400
Message-ID: <51F9DA8B.8050302@felipetonello.com>
Date: Wed, 31 Jul 2013 20:48:27 -0700
From: Felipe Ferreri Tonello <eu@felipetonello.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH 1/4] ALSA: Added jack detection kcontrol support
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com> <1374863133-6745-2-git-send-email-eu@felipetonello.com> <20130726185458.GX9858@sirena.org.uk> <CAGrhNMy7qZ8CbAjFX5Gv8OqYkit+Eqzr2zZTYXeQ-cNO22+pTQ@mail.gmail.com> <20130726224813.GB9858@sirena.org.uk> <CAGrhNMwGdMwhd5L2gGxQ=N=8nFk4L5txYmhEtLBVcFj-Etphnw@mail.gmail.com> <20130727122524.GH9858@sirena.org.uk>
In-Reply-To: <20130727122524.GH9858@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 05:25 AM, Mark Brown wrote:
> On Fri, Jul 26, 2013 at 04:13:40PM -0700, Felipe Tonello wrote:
>> On Fri, Jul 26, 2013 at 3:48 PM, Mark Brown <broonie@kernel.org> wrote:
>
>>>>> What I'd expect to happen here is that for multi function jacks we
>>>>> create a control per function if the controls are valid.
>
>> Ok, so the idea is just to change the control to type integer instead
>> of boolean, right?
>> Because as you say, the user will be able to check the type of jack
>> based on the status value, right?
>
> It might be more idiomatic and more compatible with userspace to create
> multiple controls for the jack, there was some discussion of this in the
> past I think but I can't remember the result.
>
>>> Yes.  If there's only one function supported the current code is fine
>>> but for multiple functions it's going to discard useful information.
>
>> So, what do you suggest to do that? I'm not sure if I understand what
>> you are saying.
>> When you mean function, do you mean the SND_JACK_BTN_n or the the jack
>> types, such as SND_JACK_HEADPHONE, and so on?
>
> The jack types, the buttons definitely sohuld be going up as input
> events.
>
>> If a codec creates a jack type SND_JACK_HEADSET (= SND_JACK_HEADPHONE
>> | SND_JACK_MICROPHONE). It should be created two controls, name +
>> "Headphone Jack" and name + "Microphone Jack"? If so, what about the
>> status to report? How to know which control to report?
>
> The drivers report a bitmask for status.
>

I did that but I'm not happy with the control name. Usually drivers add 
jacks like: "Headset" for a headset, "Headphone" for a headphone and so on.
I did the following: control name is jack name + (jack type) + Jack. If 
jack type == jack name, don't add (jack type) to the name.

Any suggestion how it should be?
