Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaEHQrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:47:16 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:61824 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaEHQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:47:14 -0400
Message-ID: <536BB517.8050701@linaro.org>
Date: Thu, 08 May 2014 11:47:19 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devicetree: bindings: separate CPU enable method descriptions
References: <1399505033-3368-1-git-send-email-elder@linaro.org> <CAL_JsqKoe6dz6Ncr4nKs8+6u6pZNtcyuVQpjwKenY2nHv-=Yfw@mail.gmail.com>
In-Reply-To: <CAL_JsqKoe6dz6Ncr4nKs8+6u6pZNtcyuVQpjwKenY2nHv-=Yfw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 10:13 AM, Rob Herring wrote:
> On Wed, May 7, 2014 at 6:23 PM, Alex Elder <elder@linaro.org> wrote:
>> The bindings for CPU enable methods are defined in ".../arm/cpus.txt".  As
>> additional 32-bit ARM CPUS are converted to use the "enable-method" CPU
>> property to imply a particular set of SMP operations to use, the list of these
>> methods is likely to become unwieldy.  The current documentation already
>> contains several property descriptions that are meaningful only for certain
>> enable methods.
>>
>> This patch defines a new Documentation subdirectory whose purpose is to give
>> each CPU enable method its own place to define how and when it's used, as
>> well as what other properties (optional or required) are associated with
>> the method.  The existing enable method documentation is expanded and moved
>> from ".../arm/cpus.txt" into new files accordingly.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> Please use get_maintainers.pl and copy those people.

I typically trim the list of people it generates but I
will use the full list next time.

>> ---
>> This series is available here:
>>         http://git.linaro.org/landing-teams/working/broadcom/kernel.git
>>         Branch review/enable-method-bindings
>>
>>  .../bindings/arm/cpu-enable-method/README          | 20 +++++
>>  .../bindings/arm/cpu-enable-method/arm,psci.txt    | 69 ++++++++++++++++
>>  .../arm/cpu-enable-method/qcom,gcc-msm8660         | 30 +++++++
>>  .../arm/cpu-enable-method/qcom,kpss-acc-v1         | 56 +++++++++++++
>>  .../arm/cpu-enable-method/qcom,kpss-acc-v2         | 56 +++++++++++++
>>  .../bindings/arm/cpu-enable-method/spin-table.txt  | 96 ++++++++++++++++++++++
>>  Documentation/devicetree/bindings/arm/cpus.txt     | 29 +------
>>  7 files changed, 330 insertions(+), 26 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/README
>>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/arm,psci.txt
>>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
>>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v1
>>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v2
>>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt
> 
> What about all the existing documentation:
> 
> .../arm/psci.txt

This is sort of a weird one anyway.  For arm it sets the
smp_operations vector in a way that's different from the
others, and I guess it's not strictly an enable method
anyway--at least for 32-bit arm.

The reason I started to include it here is that "psci"
(along with "spin-table") is listed as one of the
available ARM v8 enable methods.  That method does not
have any existing documentation in the "cpus.txt" file,
though it should.

Unfortunately I didn't document the right thing.  The
document ".../arm/psci.txt" you reference defines the
Power State Coordination Interface itself, but not
its use as a CPU enable method.  So documenting the
"psci" enable method is still needed (thought it'll
be brief).

I will send an update, and this time I'll fix the
"arm,psci.txt" one to be "psci.txt" and make it
actually describe the enable method.

> .../arm/msm/qcom,kpss-acc.txt

In this case, the same two strings are used for two purposes.
The first purpose, documented in the file you mention, is
defining a compatible clock controller, where this string is
the matching value for a "compatible" property.

The second purpose, currently documented in ".../arm/cpus.txt"
but here moved into .../arm/cpu-enable-method/qcom*" is to
identify the enable method, as a matching value for an
"enable-method" property.

> I can't tell what you are adding and what you are moving.

Well, I'm deleting the descriptions found in ".../arm/cpus.txt"
and replacing them with:
    Details about use of these CPU enable methods is documented
    elsewhere[1].
    ...
    [1] arm/cpu-enable-method/
In the files I've created under ".../arm/cpu-enable-method" I
started with what's there but added a brief semi-boilerplate
introduction to each, and ensured each had a relevant example
or two.

I will post version 2 shortly.  Thanks for your input.

					-Alex

> Rob
> 
. . .

