Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaFDHhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 03:37:24 -0400
Received: from goliath.siemens.de ([192.35.17.28]:57925 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbaFDHhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 03:37:23 -0400
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2014 03:37:22 EDT
Message-ID: <538EC84C.90401@siemens.com>
Date: Wed, 04 Jun 2014 09:18:36 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Emulate VMXON region correctly
References: <1399357158-8305-1-git-send-email-bsd@redhat.com>	<5369156F.1070104@redhat.com> <jpgoay9eotd.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpgoay9eotd.fsf@nelium.bos.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-03 22:11, Bandan Das wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> Il 06/05/2014 08:19, Bandan Das ha scritto:
>>> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=54521
>>>
>>> The vmxon region is unused by nvmx, but adding these checks
>>> are probably harmless and may detect buggy L1 hypervisors in
>>> the future!
>>
>> Applied to kvm/queue, unit test patches are welcome (hint, hint!).
> 
> Jan and Paolo,
> 
> Ok, I thought a little bit about this and I am wondering what 
> kind of tests we could have here. All the changes are pure 
> checks and no data is returned back to the guest. The
> vmxon code in kvm-unit-tests already does the right thing i.e
> sets the revision identifier, allocs a page for the region etc

Then try to do the wrong thing in the unit test and validate that you
get the right error report from the emulated VMX hardware.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
