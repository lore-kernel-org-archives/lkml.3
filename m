Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaBCCon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 21:44:43 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4359 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaBCCol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 21:44:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 02 Feb 2014 18:43:20 -0800
Message-ID: <52EF0294.2090103@nvidia.com>
Date: Mon, 3 Feb 2014 11:44:36 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ilia Mirkin <imirkin@alum.mit.edu>
CC: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alexandre Courbot <gnurou@gmail.com>, Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>
Subject: Re: [RFC 00/16] drm/nouveau: initial support for GK20A (Tegra K1)
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com> <CAKb7Uvg4Bqy1tHetVZBe=aekFDbgrGygc-evnSXxsoGqgoTA8A@mail.gmail.com>
In-Reply-To: <CAKb7Uvg4Bqy1tHetVZBe=aekFDbgrGygc-evnSXxsoGqgoTA8A@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 04:10 AM, Ilia Mirkin wrote:
> Hi Alexandre,
>
> On Fri, Jan 31, 2014 at 10:16 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> I guess my email address might surprise some of you, so let me anticipate some
>> questions you might have. :P Yes, this work is endorsed by NVIDIA. Several other
>> NVIDIAns (CC'd), including core GPU experts, have provided significant technical
>> guidance and will continue their involvement. Special thanks go to Terje
>> Bergstrom and Ken Adams for their invaluable GPU expertise, and Thierry Reding
>> (at FOSDEM this weekend) for help with debugging and user-space testing.
>>
>> Let me also stress that although very exciting, this effort is still
>> experimental, so I would like to make sure that nobody makes excessive
>> expectations based on these few patches. The scope of this work is strictly
>> limited to Tegra (although given the similarities desktop GPU support will
>> certainly benefit from it indirectly), and we do not have any plan to work on
>> user-space support. So do not uninstall that proprietary driver just yet. ;)
>>
>> With this being clarified, we are looking forward to getting your feedback and
>> working with you guys to bring and improve Tegra K1 support into Nouveau! :)
>
> I've sent a couple of fairly trivial comments, as you saw, and I
> suspect that others with a better understanding of the guts will have
> more substantial architectural feedback, esp after the weekend/FOSDEM.
> However, since no one's said it already -- welcome to Nouveau!

Thanks! ^_^v

One beginner question: is it appropriate to send kernel patches to the 
nouveau list in addition to dri-devel? The moderation messages I receive 
make me think that this list might rather be intended for general 
discussion.

>  From the looks of it, you could bring up a full open-source stack with
> your patches (i.e. Xorg + nouveau DDX + mesa) and use PRIME to render
> stuff (assuming the actual display hw has an X ddx).  Although I
> suspect that you're going to want to use your own drivers. Still a
> little curious if you've tried the open-source stack and whether it
> worked. [Not sure what the status is of render-node support is in
> mesa, but perhaps it's enough to try running piglit tests, if you
> can't get X going with the display HW.]

We are still testing things at libdrm level, but are eventually 
interested in bringing up the existing open-source stack. Our guess (and 
hope) is that it will work nicely almost as-is, minus the fact that the 
display hardware is not handled by Nouveau and we only support render 
nodes (I have yet to look at what the state of render nodes in Mesa is).

For X, Thierry is IIUC working on the display driver, and at some point 
these efforts should join to connect tegradrm and Nouveau using PRIME. 
We are not quite there yet, and since we are working with limited 
resources it will likely require some time, but the fact we could bring 
up a (seemingly) working Nouveau kernel driver with so little code is 
encouraging.

Thanks,
Alex.

