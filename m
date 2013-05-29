Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066Ab3E2ITJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:19:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51296 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964872Ab3E2ITF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:19:05 -0400
X-AuditID: cbfee68e-b7f276d000002279-b2-51a5b9f79c13
From: Jingoo Han <jg1.han@samsung.com>
To: "'Nikolay Balandin'" <n.a.balandin@gmail.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: "'Nikolay Balandin'" <nbalandin@dev.rtsoft.ru>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        "'Bill Pemberton'" <wfp5p@virginia.edu>,
        "'Alexandre Pereira da Silva'" <aletes.xgr@gmail.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>,
        "'Wolfram Sang'" <wsa@the-dreams.de>
References: <1369771220-5492-1-git-send-email-n.a.balandin@gmail.com>
In-reply-to: <1369771220-5492-1-git-send-email-n.a.balandin@gmail.com>
Subject: Re: [PATCH v3 1/2] drivers/misc: at24: convert to use devm_kzalloc
Date: Wed, 29 May 2013 17:19:03 +0900
Message-id: <000701ce5c45$2df28390$89d78ab0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF8BA5xOO0v0wSRidNv7JQGnu2uspnAgcpw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zI93vO5cGGmx6YWLx7M1SVouXEw4z
	WjQvXs9mcXnhJVaLjr9fGC0u75rDZvFhwxsmi/9Pn7NbrPp/lsVi5YlZzA5cHgum/WDy2Dnr
	LrvH/rlr2D36tqxi9Dh56gmLx+dNch4vjr9kCmCP4rJJSc3JLEst0rdL4Mp40uJQ8E2+4sGh
	A6wNjBMluxg5OSQETCQ2de9ihLDFJC7cW88GYgsJLGOUaH2lA1Oz/dV29i5GLqD4dEaJXXf+
	MkM4vxgl1rz+xwxSxSagJvHly2F2EFtEIEViX3MXG0gRs8ARJonHXU3sEGNdJW7Mn8/SxcjB
	wSngJrG7vwokLCzgLbHo7SwmEJtFQFXi9c0brCA2r4ClxNp+iOt4BQQlfky+xwJiMwtoSazf
	eZwJwpaX2LzmLTPEpQoSO86+ZoS4wUii+fYLNogaEYl9L94xgtwjITCVQ+LrqoVQywQkvk0+
	BHaPhICsxKYDUHMkJQ6uuMEygVFiFpLVs5CsnoVk9SwkKxYwsqxiFE0tSC4oTkovMtIrTswt
	Ls1L10vOz93ECIn3vh2MNw9YH2JMBlo/kVlKNDkfmC7ySuINjc2MLExNTI2NzC3NSBNWEudV
	a7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBoyb/q+8x7YWZeXzTklv/68q6m0XbdDxmF
	Cd4+WzcbfWHZ4F/uzCzM4nt+tv/UD1k5795XPVr2c9WUxL6ArFLzBS5PpCctfXy0hvvw5qR/
	jUZ/F5bJqHNXLou8Fzj3e8WfK8nLJLr16ldLHJ+pK/e5u8lFTKVC8tAZS5GjkwLqlr6cerP0
	bYmwEktxRqKhFnNRcSIAhcLGow0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsVy+t9jQd3vO5cGGnQf0bd49mYpq8XLCYcZ
	LZoXr2ezuLzwEqtFx98vjBaXd81hs/iw4Q2Txf+nz9ktVv0/y2Kx8sQsZgcujwXTfjB57Jx1
	l91j/9w17B59W1Yxepw89YTF4/MmOY8Xx18yBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdqKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGPMeNLiUPBNvuLBoQOsDYwTJbsYOTkkBEwktr/azg5hi0lcuLeerYuRi0NI
	YDqjxK47f5khnF+MEmte/2MGqWITUJP48uUwWIeIQIrEvuYusA5mgSNMEo+7msASQgKuEjfm
	z2fpYuTg4BRwk9jdXwUSFhbwllj0dhYTiM0ioCrx+uYNVhCbV8BSYm3/LkYIW1Dix+R7LCA2
	s4CWxPqdx5kgbHmJzWveMkNcqiCx4+xrRogbjCSab79gg6gRkdj34h3jBEahWUhGzUIyahaS
	UbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxOnknvYFzVYHGIUYCDUYmHN+Dr
	kkAh1sSy4srcQ4wSHMxKIrypgksDhXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmOrySuIN
	jU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoFRk81Z7fuFN38eZy8t
	SlOwPDK78+D2P2z9UhfSfn3dWnz0AL+/vDCbpJzE0m0HUtdknbMycgt1ZPG59sYzqlmxis3G
	4M3LU+4nTqy69UhY0WhjoOWNJp458qvnrco2fJtxImuzUGXjVKnPW7gK72/5XnUhK+eQwnX3
	Tdb1a+e96552ZmHI8yk3lFiKMxINtZiLihMBaNIKtGsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 29, 2013 5:00 AM, Nikolay Balandin wrote:
> 
> From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
> 
> Use devm_kzalloc to make cleanup paths simpler
> 
> Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

It looks good.
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han


> ---
>  drivers/misc/eeprom/at24.c |   44 +++++++++++++++-----------------------------
>  1 file changed, 15 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
> index 2baeec5..5d4fd69 100644
> --- a/drivers/misc/eeprom/at24.c
> +++ b/drivers/misc/eeprom/at24.c
> @@ -492,10 +492,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	if (client->dev.platform_data) {
>  		chip = *(struct at24_platform_data *)client->dev.platform_data;
>  	} else {
> -		if (!id->driver_data) {
> -			err = -ENODEV;
> -			goto err_out;
> -		}
> +		if (!id->driver_data)
> +			return -ENODEV;
> +
>  		magic = id->driver_data;
>  		chip.byte_len = BIT(magic & AT24_BITMASK(AT24_SIZE_BYTELEN));
>  		magic >>= AT24_SIZE_BYTELEN;
> @@ -519,8 +518,7 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  			"byte_len looks suspicious (no power of 2)!\n");
>  	if (!chip.page_size) {
>  		dev_err(&client->dev, "page_size must not be 0!\n");
> -		err = -EINVAL;
> -		goto err_out;
> +		return -EINVAL;
>  	}
>  	if (!is_power_of_2(chip.page_size))
>  		dev_warn(&client->dev,
> @@ -528,10 +526,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
> 
>  	/* Use I2C operations unless we're stuck with SMBus extensions. */
>  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> -		if (chip.flags & AT24_FLAG_ADDR16) {
> -			err = -EPFNOSUPPORT;
> -			goto err_out;
> -		}
> +		if (chip.flags & AT24_FLAG_ADDR16)
> +			return -EPFNOSUPPORT;
> +
>  		if (i2c_check_functionality(client->adapter,
>  				I2C_FUNC_SMBUS_READ_I2C_BLOCK)) {
>  			use_smbus = I2C_SMBUS_I2C_BLOCK_DATA;
> @@ -542,8 +539,7 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  				I2C_FUNC_SMBUS_READ_BYTE_DATA)) {
>  			use_smbus = I2C_SMBUS_BYTE_DATA;
>  		} else {
> -			err = -EPFNOSUPPORT;
> -			goto err_out;
> +			return -EPFNOSUPPORT;
>  		}
>  	}
> 
> @@ -553,12 +549,10 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		num_addresses =	DIV_ROUND_UP(chip.byte_len,
>  			(chip.flags & AT24_FLAG_ADDR16) ? 65536 : 256);
> 
> -	at24 = kzalloc(sizeof(struct at24_data) +
> +	at24 = devm_kzalloc(&client->dev, sizeof(struct at24_data) +
>  		num_addresses * sizeof(struct i2c_client *), GFP_KERNEL);
> -	if (!at24) {
> -		err = -ENOMEM;
> -		goto err_out;
> -	}
> +	if (!at24)
> +		return -ENOMEM;
> 
>  	mutex_init(&at24->lock);
>  	at24->use_smbus = use_smbus;
> @@ -596,11 +590,10 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  			at24->write_max = write_max;
> 
>  			/* buffer (data + address at the beginning) */
> -			at24->writebuf = kmalloc(write_max + 2, GFP_KERNEL);
> -			if (!at24->writebuf) {
> -				err = -ENOMEM;
> -				goto err_struct;
> -			}
> +			at24->writebuf = devm_kzalloc(&client->dev,
> +				write_max + 2, GFP_KERNEL);
> +			if (!at24->writebuf)
> +				return -ENOMEM;
>  		} else {
>  			dev_warn(&client->dev,
>  				"cannot write due to controller restrictions.");
> @@ -648,11 +641,6 @@ err_clients:
>  		if (at24->client[i])
>  			i2c_unregister_device(at24->client[i]);
> 
> -	kfree(at24->writebuf);
> -err_struct:
> -	kfree(at24);
> -err_out:
> -	dev_dbg(&client->dev, "probe error %d\n", err);
>  	return err;
>  }
> 
> @@ -667,8 +655,6 @@ static int at24_remove(struct i2c_client *client)
>  	for (i = 1; i < at24->num_addresses; i++)
>  		i2c_unregister_device(at24->client[i]);
> 
> -	kfree(at24->writebuf);
> -	kfree(at24);
>  	return 0;
>  }
> 
> --
> 1.7.9.5

