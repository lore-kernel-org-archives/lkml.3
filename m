Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaIWIGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:06:24 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:34470 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaIWIGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:06:15 -0400
Message-ID: <542129F1.1080608@de.ibm.com>
Date: Tue, 23 Sep 2014 10:06:09 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
CC: David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
References: <1411167805-2458-1-git-send-email-dmatlack@google.com> <541FFEDE.9030800@redhat.com> <542027F6.4050205@de.ibm.com> <542032D4.305@redhat.com> <54207668.3030502@de.ibm.com> <5420788F.9050208@redhat.com> <20140923064918.GE30733@minantech.com>
In-Reply-To: <20140923064918.GE30733@minantech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092308-4966-0000-0000-0000016A4CCA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 08:49 AM, Gleb Natapov wrote:
> On Mon, Sep 22, 2014 at 09:29:19PM +0200, Paolo Bonzini wrote:
>> Il 22/09/2014 21:20, Christian Borntraeger ha scritto:
>>> "while using trinity to fuzz KVM, we noticed long stalls on invalid ioctls. Lets bail out early on invalid ioctls". or similar?
>>
>> Okay.  David, can you explain how you found it so that I can make up my
>> mind?
>>
>> Gleb and Marcelo, a fourth and fifth opinion? :)
>>
> I agree with Christian that simpler fix is better here.
> The overhead is minimal. If we ever notice this overhead
> we can revert the patch all together since the problem it
> fixes can only be inflicted on userspace by itself and there
> are myriads other ways userspace can hurt itself.
>

Yes. Davids explanation also makes sense as a commit message. Paolo, if you use David patch with a better description of the "why" I am fine with this patch.

Christian

