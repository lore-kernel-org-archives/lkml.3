Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947096Ab3BHUvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:51:10 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:55842 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946936Ab3BHUvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:51:08 -0500
MIME-Version: 1.0
In-Reply-To: <51153365.5010109@wwwdotorg.org>
References: <1360091188-24063-1-git-send-email-swarren@wwwdotorg.org>
 <20130208144527.0D8DD3E2C01@localhost> <51153365.5010109@wwwdotorg.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 8 Feb 2013 20:50:47 +0000
X-Google-Sender-Auth: LW4TlfoP5QttHnEkWk4qA3xvjXg
Message-ID: <CACxGe6t=Bi=4ZiZFyye9iSGBe4k-pa7h2c39iruGhKi3oJjzWA@mail.gmail.com>
Subject: Re: [PATCH V8] kbuild: create a rule to run the pre-processor on
 *.dts files
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, Rob Herring <robherring2@gmail.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Scott Wood <scottwood@freescale.com>, Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 5:18 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 02/08/2013 07:45 AM, Grant Likely wrote:
>> On Tue,  5 Feb 2013 12:06:28 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> From: Stephen Warren <swarren@nvidia.com>
>>>
>>> Create cmd_dtc_cpp to run the C pre-processor on *.dts file before
>>> passing them to dtc for final compilation. This allows the use of #define
>>> and #include within the .dts file.
>>>
>>> Acked-by: Simon Glass <sjg@chromium.org>
>>> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>> Acked-by: Michal Marek <mmarek@suse.cz>
>>> Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>
>> I've applied this and was going to push it out, but I've just thought of
>> a problem that could be a show stopper. Once a dtsp file includes a C
>> header, the contents of that header become part of the Device Tree ABI.
>> If someone changes that file (ie. to renumber a series of #defines) then
>> that will break the binding. We need a way to protect against that.
>> Someone changing a .h file may make the assumption that it is only
>> kernel internal and won't realize that it has external implications.
>>
>> I'm thinking that any dts includes need to be treated in the same way as
>> userspace headers. We could put them into include/uapi and piggy back on
>> the protection already afforded by that directory, or come up with
>> something new. Any thoughts?
>
> Yes, that's true.
>
> What protection is provided by include/uapi - something programmatic or
> simply stricter review?

I believe there are tools that parse the userspace ABI and flag
incompatibilities, but also stricter review.

> I wondered if we shouldn't put the headers into the .dts directory, then
> update the kernel to include them too. That would also make it obvious
> they were part of the DT ABI.

That would also help be good. In either case the CPP options need to
only include the ABI headers. No normal headers allowed.

g.



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
