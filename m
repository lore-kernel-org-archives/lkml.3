Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaEXMAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:00:34 -0400
Received: from smtp01.online.nl ([194.134.41.31]:48498 "EHLO smtp01.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaEXMAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:00:33 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 May 2014 08:00:32 EDT
Message-ID: <53808851.7060308@topic.nl>
Date: Sat, 24 May 2014 13:53:53 +0200
From: Mike Looijmans <mike.looijmans@topic.nl>
Organization: Topic
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-i2c@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-davinci: Handle signals gracefully
References: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl> <1394779348-4084-1-git-send-email-mike.looijmans@topic.nl> <20140324161432.GA7524@katana> <20140521081727.GE2708@katana>
In-Reply-To: <20140521081727.GE2708@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Online-Scanned: by Cloudmark authority (on smtp01.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 10:17 AM, Wolfram Sang wrote:
>
>>>   		dev_err(dev->dev, "controller timed out\n");
>>>   		davinci_i2c_recover_bus(dev);
>>>   		i2c_davinci_init(dev);
>>> @@ -384,7 +384,6 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
>>>   	if (dev->buf_len) {
>>>   		/* This should be 0 if all bytes were transferred
>>>   		 * or dev->cmd_err denotes an error.
>>> -		 * A signal may have aborted the transfer.
>>>   		 */
>>>   		if (r >= 0) {
>>>   			dev_err(dev->dev, "abnormal termination buf_len=%i\n",
>>> @@ -436,22 +435,24 @@ i2c_davinci_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
>>>   	ret = i2c_davinci_wait_bus_not_busy(dev, 1);
>>>   	if (ret < 0) {
>>>   		dev_warn(dev->dev, "timeout waiting for bus ready\n");
>>> -		return ret;
>>> +		goto error;
>>
>> You are fixing the error path here to include the completion? This is a
>> seperate patch IMO.
>
> Is my remark true? I still prefer the seperate patch, but we may also
> simply update the commit message.

Your remarks is correct. All your remarks were. Problem currently is 
that I'm not assigned to a project related to the davinci so I cannot 
spend time to fix and port it (the actual platform still runs 2.6.37).

Feel free to adap my patch or comments and commit. Or wait a few weeks 
for when I have a sponsor to split and update the patch.

-- 
Mike Looijmans
