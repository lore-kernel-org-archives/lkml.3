Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3JJWvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:51:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58070 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3JJWvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:51:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        "Serge Hallyn" <serge.hallyn@canonical.com>,
        "Stephen Warren" <swarren@nvidia.com>, "Jens Axboe" <axboe@kernel.dk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>
In-Reply-To: <20131010175010.17870.58060@capellas-linux> (Sebastian Capella's
	message of "Thu, 10 Oct 2013 10:50:10 -0700")
References: <1380834638-24035-1-git-send-email-sebastian.capella@linaro.org>
	<1380834638-24035-2-git-send-email-sebastian.capella@linaro.org>
	<20131003141523.8b60ab988799af7e2b2c338b@linux-foundation.org>
	<20131003214246.24540.99218@capellas-linux>
	<20131003234735.19051.84583@capellas-linux>
	<20131010175010.17870.58060@capellas-linux>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Thu, 10 Oct 2013 15:47:45 -0700
Message-ID: <878uy0u4j2.fsf@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18yoMb9NvRh9WM/iHD8NqvGgqhcK4gJcG4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0147]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sebastian Capella <sebastian.capella@linaro.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 1/2] init/do_mounts.c: ignore final \n in name_to_dev_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Capella <sebastian.capella@linaro.org> writes:

> Quoting Sebastian Capella (2013-10-03 16:47:35)
>> Quoting Sebastian Capella (2013-10-03 14:42:46)
>> > Quoting Andrew Morton (2013-10-03 14:15:23)
>> > > On Thu,  3 Oct 2013 14:10:37 -0700 Sebastian Capella <sebastian.capella@linaro.org> wrote:
>> > > 
>> > > > Enhance name_to_dev_t to handle trailing newline characters
>> > > > on device paths.  Some inputs to name_to_dev_t may come from
>> > > > userspace where oftentimes a '\n' is appended to the path.
>> > > > Added const to the name buffer in both the function
>> > > > declaration and the prototype to reflect input buffer
>> > > > handling.
>> > > > 
>> > > > By handling trailing newlines in name_to_dev_t, userspace
>> > > > buffers may be directly passed to name_to_dev_t without
>> > > > modification.
>> > > 
>> > > We have lib/string.c:strim() - perhaps this patch would be
>> > > neater if it were to use it?
>> > 
>> > Hi Morton,
>> > 
>> > I was intending to respect the const handling of the input buffer.
>> > 
>> > The actual buffer in this case is not really const as it comes from
>> > the file buffering, but removing the const requires changing the
>> > store function defined in the kobj_attribute, and would propagate
>> > to many areas in the kernel.
>> > 
>> > Modifying the buffer and removing the const was also suggested by Pavel.
>> > After some discussion I posted this version which did not change the
>> > buffer or the prototype.
>> > 
>> > Please let me know if the preference is to modify the store function
>> > definition.
>> > 
>> > I'll prepare a patchset that removes the consts to see how much is
>> > changed.
>> > 
>> > Thanks,
>> > 
>> > Sebastian
>> 
>> Hi Andrew,
>> 
>> Sorry for calling you Morton earlier.
>> 
>> I looked into removing the const from the store function, but I'm not sure
>> this is the right idea, so I'm going to shelf that for now.
>> 
>> Please let me know your thoughts.
>> 
>> Thanks,
>> 
>> Sebastian
>  
> Ping...
>
> Hi Andrew,
>
> Do you have any feedback on this?
>
> Below are the three options considered thus far.  Do
> you have any additional suggestions or preferences?

What is wrong with requiring userspace to use echo -n ?

That by far seems the simplest and least error prone solution.

Eric
