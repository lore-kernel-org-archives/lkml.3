Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab3CGJez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:34:55 -0500
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1053 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755226Ab3CGJew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:34:52 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17103
Message-ID: <51385FA3.8080105@metafoo.de>
Date: Thu, 07 Mar 2013 10:36:35 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: =?UTF-8?B?SmFuIEzDvGJiZQ==?= <jlu@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, git@xilinx.com
Subject: Re: RFC: Zynq Clock Controller
References: <37032699-343e-485c-80e0-9b23e3706c58@VA3EHSMHS013.ehs.local> <1362570681.5269.98.camel@coredoba.hi.pengutronix.de> <f288874c-d0ae-4581-8d0f-2b9abe4d3117@CO9EHSMHS002.ehs.local>
In-Reply-To: <f288874c-d0ae-4581-8d0f-2b9abe4d3117@CO9EHSMHS002.ehs.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 06:27 PM, Sören Brinkmann wrote:
> Hi Jan,
>  
> what a small world. Good to hear from you.
> 
> On Wed, Mar 06, 2013 at 12:51:21PM +0100, Jan Lübbe wrote:
>> Hi Sören,
>>
>> On Tue, 2013-03-05 at 12:04 -0800, Sören Brinkmann wrote:
>>> For this reasons, I'd like to propose moving Zynq into the same
>>> direction. I.e. adding a clock controller with the following DT
>>> description (details may change but the general idea should become
>>> clear):
>>> 	clkc: clkc {
>>>                 #clock-cells = <1>;
>>>                 compatible = "xlnx,ps7-clkc";
>>>                 ps_clk_frequency = <33333333>;	# board x-tal
>>>                 # optional props
>>>                 gem0_emio_clk_freq = <125000000>;
>>>                 gem1_emio_clk_freq = <50000000>;
>>>                 can_mio_clk_freq_xx = <1234>; # this is possible 54 times with xx = 00..53
>>>         };

I definitely prefer the way it is right now in upstream, where we have one
dt node per clock. It is more descriptive and also more extensible. And you
also don't have to remember the clock index, and can use the phandle
directly instead.

>>
>> The clock controller should only contain properties for input frequency
>> (which can obviously not be calculated at run-time).
>>
>> Are the gem*, can* properties inputs? If they are actually outputs, the
>> corresponding frequencies should be requested by the clock consumers and
>> not hard-coded in DT.
> They are inputs. GEM and CAN have the option to be clocked through (E)MIO pins, i.e. some external clock input which cannot be derived from ps_clk like all other clocks. I plan to register a fixed rate, root clock for each of those properties, if present.

If it is a static external input clock use a "fixed-clock" dt node to
describe it. This also has the advantage that is is also possible to use a
non-static clock.

- Lars
