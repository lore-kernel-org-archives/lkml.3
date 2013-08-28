Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3H1SPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:15:50 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58681 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3H1SPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:15:48 -0400
Message-ID: <521E4C60.6030001@kernel.org>
Date: Wed, 28 Aug 2013 20:15:44 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "srinivas.pandruvada@linux.intel.com" 
	<srinivas.pandruvada@linux.intel.com>,
        "lars@metafoo.de" <lars@metafoo.de>
Subject: Re: [PATCH v5 2/2] iio: add Bosch BMA180 acceleration sensor driver
References: <1377687678-5761-1-git-send-email-o.v.kravchenko@globallogic.com> <1377687678-5761-2-git-send-email-o.v.kravchenko@globallogic.com> <20130828131724.GE10250@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130828131724.GE10250@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/13 14:17, Mark Rutland wrote:
> On Wed, Aug 28, 2013 at 12:01:18PM +0100, Oleksandr Kravchenko wrote:
>> This patch adds IIO driver for Bosch BMA180 triaxial
>> acceleration sensor.
>> http://dlnmh9ip6v2uc.cloudfront.net/datasheets/
>>                 Sensors/Accelerometers/BST-BMA180-DS000-07_2.pdf
>>
>> Stephen Warren:
>> The binding looks simple enough to me, so the binding
> 
> You can lose the above two lines, just the Acked-by is good enough. :)
> 
>> Acked-by: Stephen Warren <swarren@nvidia.com>
>> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Bonus text dropped and signoff/ack reordered as the Author goes at the top
then the chain is as people ack/sign off after that.

Applied to the togreg branch of iio.git.  Not sure on timings for the merge
window, but chances are high that this is just too late I'm afraid and will
have to wait for next time around.

Jonathan
>> ---
>>  .../devicetree/bindings/iio/accel/bma180.txt       |   24 +
>>  drivers/iio/accel/Kconfig                          |   12 +
>>  drivers/iio/accel/Makefile                         |    2 +
>>  drivers/iio/accel/bma180.c                         |  676 ++++++++++++++++++++
>>  4 files changed, 714 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/iio/accel/bma180.txt
>>  create mode 100644 drivers/iio/accel/bma180.c
>>
>> diff --git a/Documentation/devicetree/bindings/iio/accel/bma180.txt b/Documentation/devicetree/bindings/iio/accel/bma180.txt
>> new file mode 100644
>> index 0000000..c593357
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/accel/bma180.txt
>> @@ -0,0 +1,24 @@
>> +* Bosch BMA180 triaxial acceleration sensor
>> +
>> +http://omapworld.com/BMA180_111_1002839.pdf
>> +
>> +Required properties:
>> +
>> +  - compatible : should be "bosch,bma180"
>> +  - reg : the I2C address of the sensor
>> +
>> +Optional properties:
>> +
>> +  - interrupt-parent : should be the phandle for the interrupt controller
>> +
>> +  - interrupts : interrupt mapping for GPIO IRQ, it should by configured with
>> +               flags IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING
>> +
> 
> One thing I noticed from the datasheet is that this has a clock input
> (sck) and two regulator inputs (vdd and vddio). It might not always be
> the case that these are configured statically, so they may need to be
> described in the dt. It's possible that they could be added later as
> optional properties, though.
> 
> Thanks,
> Mark.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
