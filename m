Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3EHQOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:14:40 -0400
Received: from mo4.mail-out.ovh.net ([178.32.228.4]:41895 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab3EHQOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:14:38 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [RFC 1/8] serial:st-asc: Add ST ASC driver.
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <20130508155301.GB27273@kroah.com>
Date: Thu, 9 May 2013 00:03:05 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will.deacon@arm.com>, jslaby@suse.cz,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        linux-doc@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        linux-serial@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B5A00B86-5332-427E-A82A-5B71EC0979A8@jcrosoft.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022248-2153-1-git-send-email-srinivas.kandagatla@st.com> <201305081634.43498.arnd@arndb.de> <20130508153459.GA17186@kroah.com> <20130508154057.GB3041@game.jcrosoft.org> <20130508155301.GB27273@kroah.com>
To: Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1503)
X-Ovh-Tracer-Id: 8592023664791694198
X-Ovh-Remote: 124.77.142.232 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 8, 2013, at 11:53 PM, Greg KH <gregkh@linuxfoundation.org> wrote:

> On Wed, May 08, 2013 at 05:40:57PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> On 08:34 Wed 08 May     , Greg KH wrote:
>>> On Wed, May 08, 2013 at 04:34:43PM +0200, Arnd Bergmann wrote:
>>>>> +#define ASC_MAJOR		204
>>>>> +#define ASC_MINOR_START		40
>>>> 
>>>> I don't know what the current policy is on allocating major/minor numbers,
>>>> but I'm sure you cannot just reuse one that is already used.
>>> 
>>> I agree, why are you trying to create a new tty device name?  Can't you
>>> use the existing ttyS name and minor number as you will not have any
>>> other type of serial device on this system?
>> 
>> Greg on ST STB for more than 10 years we use ttyASC I'll prefer ttySx
> 
> For 10+ years you have had an out-of-tree serial driver?
yes ST have it out of tree for very long time even I puts them to come mainline

>  What
> major/minor numbers did you use for it?

http://git.stlinux.com/?p=havana/com.st.havana.kernel.git;a=blob;f=drivers/serial/stm-asc.h;h=79e003ffeb21df55a6af94774fc9c4b3d8de18e9;hb=HEAD

  52 #define ASC_MAJOR               204
  53 #define ASC_MINOR_START         40

same as in this patch

> 
>> on the DTB SoC you have one one IP present the st,asc
> 
> I don't understand, what do you mean by this?
> 
> confused,

just mention there is not hardware reason to not use the generic ttySx in place of ttyAS
as we have only one IP that handle serial on this family of SoC

personally I'll switch to ttySx

Best Regards,
J.